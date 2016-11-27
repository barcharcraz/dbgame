//
// Created by barch on 10/17/2016.
//

#include "glshaders.h"
#include "gldata.h"
#include <glbinding/gl/gl.h>
#include <odb/core.hxx>
#include <odb/database.hxx>
#include <dbgame/dataapi.h>
using namespace odb;
using namespace gl;
using namespace std;
using namespace dbgame::data;
namespace dbgame {
namespace rendering {
namespace gl {
    
	void compile_shaders(database& db) {
		transaction t(db.begin());
		result<shader> res = db.query(query<shader>{query<shader>::handle.is_null()});
		for (shader& s : res) {
			s.handle = glCreateShader(s.shader_type);
			db.update(s);
		}
		res = db.query(query<shader>{query<shader>::compiled == false});
		for (shader& s : res) {
			const char* txt = s.shader_text.c_str();
			glShaderSource(s.handle, 1, &txt, nullptr);
			glCompileShader(s.handle);
			GLint result = 0;
			glGetShaderiv(s.handle, GL_COMPILE_STATUS, &result);
			s.compiled = result != (int)GL_FALSE;
			GLint logsize = 0;
			glGetShaderiv(s.handle, GL_INFO_LOG_LENGTH, &logsize);
			string log(logsize, '\0');
			glGetShaderInfoLog(s.handle, 0, 0, &log[0]);
			s.errors = log;
			db.update(s);
		}
		t.commit();
	}

	void compile_programs(database& db) {
		transaction t(db.begin());
		using result = result<program>;
		using query = query<program>;
		result res = db.query(query{ query::handle.is_null() });
		for (program& p : res) {
			GLuint program = glCreateProgram();
			p.handle = program;
			db.update(p);
		}
		res = db.query(query{ query::compiled == false });
		for (program& p : res) {
			if (p.vertex) glAttachShader(p.handle, p.vertex->handle);
			if (p.tess_control) glAttachShader(p.handle, p.tess_control->handle);
			if (p.tess_eval) glAttachShader(p.handle, p.tess_eval->handle);
			if (p.geom) glAttachShader(p.handle, p.geom->handle);
			if (p.fragment) glAttachShader(p.handle, p.fragment->handle);
			if (p.compute) glAttachShader(p.handle, p.compute->handle);
			glLinkProgram(p.handle);
            GLint result = 0;
            glGetProgramiv(p.handle, GL_LINK_STATUS, &result);
            p.compiled = result != (int)GL_FALSE;
			int max_length = 0;
			glGetProgramiv(p.handle, GL_INFO_LOG_LENGTH, &max_length);
            string log(max_length, '\0');
            glGetProgramInfoLog(p.handle, 0, 0, &log[0]);
            p.errors = log;
            db.update(p);
		}
        t.commit();
	}

}
}
}
