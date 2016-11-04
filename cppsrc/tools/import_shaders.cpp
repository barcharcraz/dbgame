

#include "import_shaders.h"
#include <dbgame/dataapi.h>
#include <string>
#include <sstream>
#include <iostream>
#include <vector>
#include <unordered_map>
#include <glbinding/gl/gl.h>
#include <boost/filesystem.hpp>
using namespace std::literals::string_literals;
using namespace std;
using namespace gl;
using namespace boost::filesystem;
using namespace dbgame::data;
static const unordered_map<string, GLenum> type_mapping{
    {".ps"s, GL_FRAGMENT_SHADER},
    {".vs"s, GL_VERTEX_SHADER}
};

shader load_shader(const string& file, GLenum shader_type = GL_INVALID_ENUM) {
    ostringstream ss;
    std::ifstream f(file);
    ss << f.rdbuf();
    string lines = ss.str();
    shader result;
    result.compiled = false;
    result.errors = ""s;
    result.handle = 0;
    int idx = file.rfind("/");
    result.shader_name = file.substr(idx);
    
    if(shader_type == GL_INVALID_ENUM) {
        idx = file.rfind(".");
        string ext = file.substr(idx);
        shader_type = type_mapping.at(ext);
    }
    
    result.shader_text = lines;
    result.shader_type = shader_type;
    return result;
}


vector<shader> load_shader_directory(const string& dir) {
    vector<shader> result;
    for(auto& ent : directory_iterator(dir)) {
        auto ext = ent.path().extension().string();
        if(type_mapping.count(ext) > 0) {
            result.push_back(load_shader(ent.path().string()));
        }
    }
    return result;
}
