#pragma once
#include <dbgame/dataapi.h>
#include <glbinding/gl/gl.h>
#include <vector>
#include <string>
namespace dbgame {
dbgame::data::shader load_shader(std::string& file, gl::GLenum type);
std::vector<dbgame::data::shader> load_shader_directory(const std::string& dir);
}
