//
// Created by barch on 10/15/2016.
//

#pragma once
#include <glbinding/gl/enum.h>
#include <odb/core.hxx>
#include <memory>
#include <dbgame/dataapi/data_rendering.h>

class call {

public:
    call() = default;
    int program;
    int vao;
    int count;
    gl::GLenum prim_type;
private:
    friend class odb::access;
#pragma db id auto
    unsigned int id;
};

#pragma db object table("opengl_vbo")
class vbo {
public:
    std::shared_ptr<mesh> mesh;
    unsigned int position;
    unsigned int normal;
    unsigned int texcoord;
private:
    friend class odb::access;
    #pragma db id auto
    unsigned int id;
};

#pragma db object table("opengl_idx")
class idx {
public:
    std::shared_ptr<mesh> mesh;
    unsigned int buf;
private:
    friend class odb::access;

    #pragma db id auto
    unsigned int id;
};

#pragma db view object(mesh) object(vbo)
struct vbo_mesh_view {
    std::shared_ptr<mesh> mesh;
    std::shared_ptr<vbo> vbo;
};

#pragma  db view object(mesh) object(idx)
struct idx_mesh_view {
    std::shared_ptr<mesh> mesh;
    std::shared_ptr<idx> idx;
};