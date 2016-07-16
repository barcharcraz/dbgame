import vecmath
import datainterface
discard """
type Mesh* = object
    name*: string
    vertices*: seq[Vec3f]
    normals*: seq[Vec3f]
    tangents*: seq[Vec3f]
    bitangents*: seq[Vec3f]
    indices*: seq[int32]
    texCoords*: seq[Vec3f]
"""
stored:
    type Mesh* = select(vertices: StoredArray[Vec3f], indices: StoredArray[int32]) `from` mesh_data
