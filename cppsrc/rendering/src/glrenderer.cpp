//
// Created by barch on 10/15/2016.
//
#include "glrenderer.h"
#include <dbgame/dataapi.h>
#include <odb/core.hxx>
#include <odb/database.hxx>
#include <glbinding/gl/gl.h>
#include "gldata.h"
#include <gldata_odb.h>
#include <memory>
using namespace std;
using namespace odb;
using namespace Eigen;
using namespace gl;
using namespace dbgame::data;
namespace dbgame {
namespace rendering {
namespace gl {

void create_vertex_buffers(database &db) {
    transaction t(db.begin());
    result<vbo_mesh_view> meshes = db.query(query<vbo_mesh_view> {query<vbo_mesh_view>::vbo::id.is_null()});
    for (vbo_mesh_view &res : meshes) {
        vbo mesh_vbo;
        int texcoord_size = 0;
        for (VectorXf &v : res.mesh->verts[0]->texcoords) {
            texcoord_size += (int)sizeof(float) * (int)v.size();
        }
        int num_verts = (int)res.mesh->verts.size();
        glGenBuffers(1, &mesh_vbo.position);
        glGenBuffers(1, &mesh_vbo.normal);
        glGenBuffers(1, &mesh_vbo.texcoord);
        glBindBuffer(GL_ARRAY_BUFFER, mesh_vbo.position);
        glBufferStorage(GL_ARRAY_BUFFER, num_verts * sizeof(Vector3f), nullptr, GL_MAP_WRITE_BIT);
        Vector3f *buf = (Vector3f *) glMapBuffer(GL_ARRAY_BUFFER, GL_WRITE_ONLY);

        for (auto &vert : res.mesh->verts) {
            *buf++ = vert->position;
        }
        glUnmapBuffer(GL_ARRAY_BUFFER);
        glBindBuffer(GL_ARRAY_BUFFER, mesh_vbo.normal);
        glBufferStorage(GL_ARRAY_BUFFER, num_verts * sizeof(Vector3f), nullptr, GL_MAP_WRITE_BIT);
        buf = (Vector3f *) glMapBuffer(GL_ARRAY_BUFFER, GL_WRITE_ONLY);
        for (auto &vert : res.mesh->verts) {
            *buf++ = vert->normal;
        }
        glUnmapBuffer(GL_ARRAY_BUFFER);
        glBindBuffer(GL_ARRAY_BUFFER, mesh_vbo.texcoord);
        glBufferStorage(GL_ARRAY_BUFFER, num_verts * texcoord_size, nullptr, GL_MAP_WRITE_BIT);
        float *texbuf = (float *) glMapBuffer(GL_ARRAY_BUFFER, GL_WRITE_ONLY);
        for (auto &vert: res.mesh->verts) {
            for (auto &texcoord: vert->texcoords) {
                memmove(texbuf, texcoord.data(), sizeof(float) * texcoord.size());
                texbuf += texcoord.size();
            }
        }
		mesh_vbo.texcoord_stride = texcoord_size;
        glUnmapBuffer(GL_ARRAY_BUFFER);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        mesh_vbo.mesh = res.mesh;
        db.persist(mesh_vbo);
    }
    t.commit();
}

void create_index_buffers(database &db) {
    transaction t(db.begin());
    result<idx_mesh_view> meshes = db.query(query<idx_mesh_view> {query<idx_mesh_view>::idx::id.is_null()});
    for (idx_mesh_view &res : meshes) {
        idx bufs;
        glGenBuffers(1, &bufs.buf);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, bufs.buf);
        glBufferStorage(GL_ELEMENT_ARRAY_BUFFER, sizeof(unsigned int) * res.mesh->idx.size(), res.mesh->idx.data(), GL_NONE_BIT);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        bufs.mesh = res.mesh;
        db.persist(bufs);
    }
    t.commit();
}

void create_vertex_arrays(database& db) {
	transaction t(db.begin());
    result<vao_view> vaos = db.query(query<vao_view>{query<vao_view>::vao::id.is_null()});
    for(vao_view &res : vaos) {
        vao vertarray;
        glGenVertexArrays(1, &vertarray.handle);
        glBindVertexArray(vertarray.handle);
        glEnableVertexAttribArray(0);
        glEnableVertexAttribArray(1);
        glEnableVertexAttribArray(2);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, res.idx->buf);
        glBindBuffer(GL_ARRAY_BUFFER, res.vbo->position);
        glVertexAttribPointer(0, 3, GL_FLOAT, false, 0, nullptr);
        glBindBuffer(GL_ARRAY_BUFFER, res.vbo->normal);
        glVertexAttribPointer(1, 3, GL_FLOAT, false, 0, nullptr);
        //TODO: also bind texture coords
        glBindVertexArray(0);
        vertarray.mesh = res.mesh;
        db.persist(vertarray);
    }
    t.commit();
}

void create_opengl_calls(database& db) {
    transaction t(db.begin());
    auto result = db.query<vao>();
    auto prog = db.load<data::program>(0);
    for(vao &res : result) {
        call c;
        c.prim_type = GL_TRIANGLES;
        c.count = res.mesh->idx.size();
        c.program = prog->handle;
        c.vao = res.handle;
        db.persist(c);
    }
    t.commit();
}

void execute_draws(database& db) {
    transaction t(db.begin());
    auto result = db.query<call>();
    for(call &res : result) {
        glUseProgram(res.program);
        glBindVertexArray(res.vao);
        glDrawElements(GL_TRIANGLES, res.count, GL_UNSIGNED_INT, nullptr);
    }
    t.commit();
}

}
}
}

