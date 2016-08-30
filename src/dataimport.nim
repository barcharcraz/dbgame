import sqlite3
import db_sqlite
import sqlite3_utils
import assimp
import os
import tables
import hashes


type FileIndices = object
  mesh_ids: seq[int64]
  node_ids: Table[PNode, int64]
  texture_ids: seq[int64]


proc importMesh(db: PSqlite3, name: string, mesh: TMesh, scene: int64): int64 =
  var stmt: Pstmt
  var res = prepare_v2(db, """INSERT OR REPLACE INTO mesh_data (scene, name, vertices, normals, tangents, bitangents, indices, texCoords)
                              VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
             -1, stmt, nil)
  if res != SQLITE_OK: dbError(db)
  check(db): stmt.bind_int64(1, scene)
  if name == nil:
    check(db): stmt.bind_null(2)
  else:
    check(db): stmt.bind_text(2, name, -1, SQLITE_STATIC)
  res = stmt.bind_blob(3, mesh.vertices, mesh.vertexCount * 3 * sizeof(float32).int32, SQLITE_STATIC)
  if res != SQLITE_OK: dbError(db)
  res = stmt.bind_blob(4, mesh.normals, mesh.vertexCount * 3 * sizeof(float32).int32, SQLITE_STATIC)
  if res != SQLITE_OK: dbError(db)
  res = stmt.bind_blob(5, mesh.tangents, mesh.vertexCount * 3 * sizeof(float32).int32, SQLITE_STATIC)
  if res != SQLITE_OK: dbError(db)
  res = stmt.bind_blob(6, mesh.bitTangents, mesh.vertexCount * 3 * sizeof(float32).int32, SQLITE_STATIC)
  if res != SQLITE_OK: dbError(db)
  var indices = newSeq[int32]()
  for i in 0..mesh.faceCount-1:
    var face = mesh.faces[i]
    for j in 0..face.indexCount-1:
      indices.add(face.indices[][j])
  res = stmt.bind_blob(7, addr indices[0], cast[int32](len(indices) * sizeof(int32)), SQLITE_STATIC)
  if res != SQLITE_OK: dbError(db)
  res = stmt.bind_blob(8, mesh.texCoords[0], mesh.vertexCount * 3 * sizeof(float32).int32, SQLITE_STATIC)
  if res != SQLITE_OK: dbError(db)
  res = stmt.step()
  if res != SQLITE_DONE: dbError(db)
  res = stmt.finalize()
  if res != SQLITE_OK: dbError(db)
  result = sqlite3.last_insert_rowid(db)
  #db.exec(sql"INSERT INTO mesh_data (name, vertices, normals, tangents, indices, texCoords) VALUES (?, ?, ?, ?, ?, ?)",
  #        name, vertices, normals, tangents, indices, texCoords)

proc importMesh(db: PSqlite3, mesh: TMesh, scene: int64): int64 =
  if mesh.name.length > 0: importMesh(db, $mesh.name, mesh, scene)
  else: importMesh(db, nil, mesh, scene)

proc importTexture(db: PSqlite3, texture: PTexture, scene: int64): int64 =
  var size: int64
  if texture.height == 0:
    size = texture.width
  else:
    size = texture.width * texture.height * sizeof(TTexel)
  var stm: Pstmt
  check(db): db.prepare_v2("""INSERT INTO texture_data (scene, width, height, format, data)
                              VALUES (?, ?, ?, ?, ?)""", -1, stm, nil)
  check(db): stm.bind_int64(1, scene)
  check(db): stm.bind_int(2, texture.width)
  check(db): stm.bind_int(3, texture.height)
  check(db): stm.bind_text(4, cast[cstring](addr texture.achFormatHint), 4, SQLITE_STATIC)
  check(db): stm.bind_blob(5, texture.pcData, size.int32, SQLITE_STATIC)
  check(db): stm.step()
  check(db): stm.finalize()
  result = db.last_insert_rowid()

proc importNode(db: PSqlite3, node: PNode, scene: int64): int64 =
  var stm: Pstmt
  check(db): db.prepare_v2("""INSERT INTO node_data (scene, name, transform) VALUES
                    (?, ?, ?)""", -1, stm, nil)
  check(db): stm.bind_int64(1, scene)
  check(db): stm.bind_text(2, addr node.name.data[0], node.name.length.int32, SQLITE_STATIC)
  check(db): stm.bind_blob(3, addr node.transformation, sizeof(node.transformation).int32, SQLITE_STATIC)
  check(db): stm.step()
  check(db): stm.finalize()
  return db.last_insert_rowid()

proc fixupNodes(db: PSqlite3, indices: FileIndices) =
  var stm: Pstmt
  check(db): db.prepare_v2("""INSERT INTO node_mesh_data (node, mesh)
                              VALUES (?, ?)""", -1, stm, nil)
  var child_stm: Pstmt
  check(db): db.prepare_v2("""UPDATE node_data SET parent = ? WHERE id = ?""", -1, child_stm, nil)
  for n, i in indices.node_ids:
    check(db): stm.bind_int64(1, i)
    check(db): child_stm.bind_int64(1, i)
    for j in 0..n.meshCount-1:
      check(db): stm.bind_int64(2, indices.mesh_ids[n.meshes[j]])
      check(db): stm.step()
      check(db): stm.reset()
    for c in 0..n.childrenCount-1:
      check(db): child_stm.bind_int64(2, indices.node_ids[n.children[c]])
      check(db): child_stm.step()
      check(db): child_stm.reset()
  check(db): stm.finalize()
  check(db): child_stm.finalize()

proc hash(x: PNode): Hash = hash(cast[pointer](x))
proc importScene(db: PSqlite3, file: string) =
  var data = readFile(file)
  var scene = aiImportFile(file, aiProcessPreset_TargetRealtime_Quality)
  if scene == nil:
    raise newException(OSError, $geterror())
  var stm: Pstmt
  check(db): prepare_v2(db, "INSERT INTO scene_data (filename, filedata) VALUES (?, ?)", -1, stm, nil)
  check(db): stm.bind_text(1, file, -1, SQLITE_STATIC)
  check(db): stm.bind_blob(2, addr data[0], len(data).cint, SQLITE_STATIC)
  check(db): stm.step()
  check(db): stm.finalize()
  var scene_id = last_insert_rowid(db)
  var indices: FileIndices
  indices.mesh_ids = @[]
  indices.node_ids = initTable[PNode, int64]()
  indices.texture_ids = @[]
  for i in 0..scene.meshCount-1:
    indices.mesh_ids.add(importMesh(db, scene.meshes[i][], scene_id))
  for i in 0..scene.textureCount-1:
   indices.texture_ids.add(db.importTexture(scene.textures[i], scene_id))
  var nodes: seq[PNode] = @[scene.rootNode]
  while nodes.len > 0:
    var node = nodes.pop()
    var id = importNode(db, node, scene_id)
    indices.node_ids.add(node, id)
    for i in 0..node.childrenCount-1:
      nodes.add(node.children[i])
  fixupNodes(db, indices)

when isMainModule:
  var db = load_db(paramStr(1))
  importScene(db, paramStr(2))
  db.save_db(paramStr(3))
  discard sqlite3.close(db)
