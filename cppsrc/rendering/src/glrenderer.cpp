//
// Created by barch on 10/15/2016.
//

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
            texcoord_size += sizeof(float) * v.size();
        }
        int num_verts = res.mesh->verts.size();
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
        glUnmapBuffer(GL_ARRAY_BUFFER);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        mesh_vbo.mesh = res.mesh;
        db.persist(mesh_vbo);
    }
    t.commit();
};

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



}
}
}

