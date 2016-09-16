#pragma once
#include <dbgame/dataapi.h>
#include <glbinding/gl/gl.h>
#include <vector>
#include <string>
shader load_shader(std::string& file, gl::GLenum type);
std::vector<shader> load_shader_directory(const std::string& dir);
