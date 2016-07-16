import sqlite3
import sqlite3_utils
import db_sqlite
import strutils
import macros
import parsesql
import sequtils
import streams
import queues
export sqlite3
import typetraits
type UncheckedArray* {.unchecked.} [T] = array[1,T]
type StoredArray*[T] = object
  size: int32
  data: ptr UncheckedArray[T]
proc len*(a: StoredArray): int = int(a.size)
proc `[]`*[T](a: StoredArray[T], i: int): T =
  if i < 0 or i >= a.size: raise newException(IndexError, "Index Out of Range")
  result = a.data[][i]
proc `[]`*[T](a: var StoredArray[T], i: int): var T =
  if i < 0 or i >= a.size: raise newException(IndexError, "Index Out of Range")
  result = a.data[][i]
iterator items*[T](a: StoredArray[T]): T {.inline.} =
  var i = 0
  while i < len(a):
    yield a[i]
    inc(i)

proc loadCol[T](stmt: Pstmt, col: int32, dest: var StoredArray[T]) =
  dest.data = cast[ptr UncheckedArray[T]](stmt.column_blob(col))
  dest.size = int32(stmt.column_bytes(col) div sizeof(T))
proc loadCol[T](stmt: Pstmt, col: int32, dest: var seq[T]) =
  var blobptr = stmt.column_blob(col)
  var size = stmt.column_bytes(col)
  if blobptr == nil:
    dest = nil
    return
  newSeq(dest, size div sizeof(T) )
  moveMem(addr dest[0], blobptr, size)

proc loadCol(stmt: Pstmt, col: int32, dest: var string) =
  dest = $stmt.column_text(col)

proc loadRow[T](stmt: Pstmt): T =
  var col: int32 = 0
  for name, f in fieldpairs(result):
    #echo name
    loadCol(stmt, col, f)
    inc(col)

proc prepLoad[T](db:Psqlite3, table: string): Pstmt =
  var dummy: T
  var query = "SELECT "
  for name, value in fieldpairs(dummy):
    query &= name & ","
  query = query.strip(chars = {','})
  query &= " FROM " & table
  #echo query
  check(db): prepare_v2(db, query, -1, result, nil)

iterator load*[T](db: PSqlite3, typ: typedesc[T], tableName: string): T =
  var stm = prepLoad[T](db, tableName)
  while stm.step() == SQLITE_ROW:
    yield loadRow[T](stm)
  check(db): stm.finalize()
proc load*[T](db: PSqlite3, stmt: Pstmt): seq[T] =
  result = @[]
  while stmt.step() == SQLITE_ROW:
    result.add(loadRow[T](stmt))

proc load*[T](db: PSqlite3, table: string): seq[T] =
  var stmt = prepLoad[T](db, table)
  result = load[T](db, stmt)
  check(db): stmt.finalize()

proc saveCol[T](db: PSqlite3, stm: Pstmt, col: int32, src: var openArray[T]) =
  check(db): stm.bind_blob(col, addr src[0], int32(len(src) * sizeof(T)), SQLITE_STATIC)
proc saveCol[T](db: PSqlite3, stm: Pstmt, col: int32, src: openArray[T]) =
  var src = @src
  saveCol[T](db, stm, col, src)


proc saveCol(db: PSqlite3, stm: PStmt, col: int32, src: string) =
  check(db): stm.bind_text(col, src, -1, SQLITE_STATIC)

proc saveRow[T](db: PSqlite3, stm: Pstmt, src: T) =
  var col: int32 = 1
  for name, f in fieldpairs(src):
    saveCol(db, stm, col, f)
    inc(col)

proc store*[T](db: PSqlite3, stm: Pstmt, itms: openarray[T]) =
  for i, itm in pairs(itms):
    saveRow(db, stm, itm)
    check(db): stm.step()
    check(db): stm.reset()
proc store*[T](db: PSqlite3, itms: openarray[T], table: string) =
  var stm: Pstmt
  var dummy: T
  var query = "INSERT INTO " & table & "("
  var cols: int
  for name, value in fieldpairs(dummy):
    query &= name & ","
    inc(cols)
  query = query.strip(chars = {','})
  query &= ") VALUES ( "
  for i in 1..cols:
    query &= "?,"
  query = query.strip(chars = {','})
  query &= ")"
  echo query
  check(db): prepare_v2(db, query, -1, stm, nil)
  store[T](db, stm, itms)
  check(db): stm.finalize()



discard """
macro stored*(s: string, t: stmt): stmt {.immediate.} =
  var ident = getType(t)
  result = quote do:
    `t`
    proc load*[`ident`](db: PSqlite3): seq[`ident`] = load[`ident`](db, `s`)
"""


macro stored*(def: untyped): stmt =
  echo treeRepr(def)
  var defs = initQueue[NimNode]()
  defs.add(def)
  result = newNimNode(nnkStmtList)
  var should_export = false
  var parents: seq[NimNode] = @[]
  var colnames: seq[string] = @[]
  var typident: NimNode
  while defs.len > 0:
    var def = defs.dequeue()
    case def.kind
    of {nnkObjConstr, nnkCommand}:
      var ident: NimNode
      if def[0].kind == nnkAccQuoted: ident = def[0][0]
      elif def[0].kind == nnkIdent: ident = def[0]
      else:
        for c in def:
          defs.add(c)
        continue

      case $ident
      of "select":
        echo "SELECT"
        var tupleDef = newNimNode(nnkTupleTy)
        for c in def:
          case c.kind
          of nnkExprColonExpr:
            colnames.add($c[0])
            tupleDef.add(
              newNimNode(nnkIdentDefs).add(
                c[0],
                c[1],
                newEmptyNode()
              )
            )
          else: discard
        parents.add(tupleDef)
        echo treerepr(result)
      of "from":
        echo "FROM"
        var table_name = $def[1].ident
        var loadident = ident("load")
        var saveident = ident("store")
        if should_export:
          loadident = newTree(nnkPostfix, ident("*"), ident("load"))
          saveident = newTree(nnkPostfix, ident("*"), ident("store"))
        var node = newStmtList(
          newNimNode(nnkProcDef).add(
            loadident,
            newEmptyNode(),
            newNimNode(nnkGenericParams).add(
              newTree(nnkIdentDefs, typident, newEmptyNode(), newEmptyNode())
            ),
            newNimNode(nnkFormalParams).add(
              newTree(nnkBracketExpr, newIdentNode(!"StoredArray"), typident),
              newIdentDefs(ident("db"), ident("PSqlite3")),
              newIdentDefs(ident("t"), newTree(nnkBracketExpr, ident("typedesc"), typident)),
            ),
            newEmptyNode(),
            newEmptyNode(),
            newStmtList(
              newCall(newTree(nnkBracketExpr, ident("load"), typident), ident("db"), newLit(table_name))
            )
          ),
          newNimNode(nnkProcDef).add(
            saveident,
            newEmptyNode(),
            newNimNode(nnkGenericParams).add(
              newTree(nnkIdentDefs, typident, newEmptyNode(), newEmptyNode())
            ),
            newNimNode(nnkFormalParams).add(
              newEmptyNode(),
              newIdentDefs(ident("db"), ident("PSqlite3")),
              newIdentDefs(ident("t"), newTree(nnkBracketExpr, ident("openarray"), typident)),
            ),
            newEmptyNode(),
            newEmptyNode(),
            newStmtList(
              newCall(newTree(nnkBracketExpr, ident("store"), typident), ident("db"), ident("t"), newLit(table_name))
            )
          )
        )
        #var node = quote do:
        #  proc load(db: PSqlite3, x: typedesc[`typident`]): seq[`typident`] = load[`typident`](db, `table_name`)
        parents.add(node)
      else: discard
      var res = parents.pop()
      while parents.len > 0:
        var nxt = parents.pop()
        nxt.add(res)
        res = nxt
      result.add(res)
    of nnkTypeDef:
      expectKind(def[0], {nnkIdent, nnkPostfix})
      typident = def[0]
      if def[0].kind == nnkPostfix:
        typident = def[0][1]
        should_export = true
      var node = newNimNode(nnkTypeDef).add(
        def[0],
        newEmptyNode()
      )
      parents.add(node)
      defs.add(def[2])
    of nnkTypeSection:
      var node = newNimNode(nnkTypeSection)
      parents.add(node)
      defs.add(def[0])
    of nnkStmtList:
      defs.add(def[0])
    else: discard
      #{.error: "Invalid stored statement".}
  echo "RESULT"
  echo treerepr(result)



dumpTree:
  proc load*[int](db: PSqlite3, x: typedesc[int]): seq[int] = load[int](db, "mesh_data")
  proc store*[int](db: PSqlite3, x: openarray[int]) = save[int](db, "mesh_data")
when isMainModule:
  import os
  #type test = tuple[name: int, values: seq[int]]



  type
    TestVec = tuple[x: float32, y: float32, z: float32]
  type Mesh = object
    name: string
    vertices: seq[TestVec]
    normals: seq[TestVec]
    tangents: seq[TestVec]
    bitangents: seq[TestVec]
    indices: seq[int32]
    texCoords: seq[TestVec]
  stored:
    type Scene* = select(filename: string) `from` scene_data
  var db: PSqlite3
  discard open(paramStr(1), db)
  var testScenes = db.load(Scene)
  for s in testScenes: echo s.filename
  var testScene = testScenes[0]
  testScene.filename = "wow, such magic"
  db.store([testScene])
  #var test = load[Mesh](db, "mesh_data")
