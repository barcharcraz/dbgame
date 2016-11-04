#pragma once
#include <odb/core.hxx>
#include <glbinding/gl/enum.h>
#include <string>
#include <memory>

namespace dbgame { namespace data {


#pragma db object table("opengl_shader")
class shader {
public:
    shader() = default;
    gl::GLenum shader_type;
    std::string shader_name;
    std::string shader_text;
    std::string errors;
    unsigned int handle;
    bool compiled;
private:
    friend class odb::access;
    #pragma db id auto 
    unsigned int id;
};

#pragma db object table("opengl_program")
class program {
public:
    program() = default;
    std::shared_ptr<shader> vertex;
    std::shared_ptr<shader> tess_control;
    std::shared_ptr<shader> tess_eval;
    std::shared_ptr<shader> geom;
    std::shared_ptr<shader> fragment;
    std::shared_ptr<shader> compute;
	std::string errors;
	unsigned int handle;
	bool compiled;
private:
    friend class odb::access;
    #pragma db id auto
    unsigned int id;
};
}
}
