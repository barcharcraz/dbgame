
#include <odb/core.hxx>
#include <odb/database.hxx>
#include <glbinding/gl45core/gl.h>
#include <dbgame/dataapi.h>
using namespace gl45core;

void do_calls(odb::database& db) {
    using query = odb::query<call>;
    using result = odb::result<call>;
    result res = db.query<call>(query{});
    for(auto& call : res) {
        glUseProgram(call.program);
        glBindVertexArray(call.vao);
        glDrawElements(call.prim_type, call.count, GL_UNSIGNED_INT, 0);
    }
}

void compile_shaders(odb::database& db) {
    using query = odb::query<shader>;
    using result = odb::result<shader>;
    odb::transaction t(db.begin());
    result res = db.query(query{query::handle.is_null()});
    for(shader& s : res) {
        s.handle = glCreateShader(s.shader_type);
        db.update(s);
    }
    res = db.query(query{query::compiled == false});
    for(shader& s : res) {
        const char* txt = s.shader_text.c_str();
        glShaderSource(s.handle, 1, &txt, nullptr);
        glCompileShader(s.handle);
        GLint result = 0;
        glGetShaderiv(s.handle, GL_COMPILE_STATUS, &result);
        s.compiled = result != (int)GL_FALSE;
        GLint logsize = 0;
        glGetShaderiv(s.handle, GL_INFO_LOG_LENGTH, &logsize);
        std::string log(logsize, '\0');
        glGetShaderInfoLog(s.handle, 0, 0, &log[0]);
        s.errors = log;
        db.update(s);
    }
    t.commit();
}
