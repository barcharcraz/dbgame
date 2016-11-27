//
// Created by barch on 10/15/2016.
//

#pragma once

#include <glbinding/gl/enum.h>
#include <odb/core.hxx>
#include <memory>
#include <dbgame/dataapi/data_rendering.h>
namespace dbgame {
namespace data {
#pragma db object table("opengl_call")
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
    std::shared_ptr<data::mesh> mesh;
    unsigned int position;
    unsigned int normal;
    unsigned int texcoord;
	unsigned int texcoord_stride;
private:
    friend class odb::access;
    #pragma db id auto
    unsigned int id;
};

#pragma db object table("opengl_idx")
class idx {
public:
    std::shared_ptr<data::mesh> mesh;
    unsigned int buf;
private:
    friend class odb::access;

    #pragma db id auto
    unsigned int id;
};
#pragma db object
class vao {
public:
	std::shared_ptr<data::mesh> mesh;
	unsigned int handle;
private:
	#pragma db id auto
	unsigned int id;
private:
	friend class odb::access;
};

#pragma db view object(mesh) object(vbo inner) object(idx inner) object(vao left)
struct vao_view {
	std::shared_ptr<data::mesh> mesh;
	std::shared_ptr<data::vbo> vbo;
	std::shared_ptr<data::idx> idx;
	std::shared_ptr<data::vao> vao;
};

#pragma db view object(mesh) object(vbo)
struct vbo_mesh_view {
    std::shared_ptr<data::mesh> mesh;
    std::shared_ptr<data::vbo> vbo;
};

#pragma  db view object(mesh) object(idx)
struct idx_mesh_view {
    std::shared_ptr<data::mesh> mesh;
    std::shared_ptr<data::idx> idx;
};
}
}
