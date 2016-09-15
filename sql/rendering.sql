CREATE TABLE rendering_meshes (
    mesh_id integer primary key,
    vertex blob,
    normal blob,
    tangent blob,
    texcoord blob,
    index blob
)