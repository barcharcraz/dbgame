//
// Created by barch on 9/30/2016.
//

#include "import_assets.h"
#include <dbgame/dataapi.h>
#include <string>
#include <queue>
#include <utility>
#include <odb/core.hxx>
#include <odb/database.hxx>
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>
#include <assimp/ProgressHandler.hpp>

#include <exception>

using namespace std;
namespace dbgame {
//returns a vector with the database id for each inserted mesh
vector<unsigned int> import_meshes(const aiScene *scene, odb::database &db) {
    using namespace Eigen;
    vector<unsigned int> result;
    odb::transaction t(db.begin());
    for (int i = 0; i < scene->mNumMeshes; ++i) {
        aiMesh *amesh = scene->mMeshes[i];
        mesh mesh;
        mesh.verts.resize(amesh->mNumVertices);
        for (int j = 0; j < mesh.verts.size(); ++j) {
            mesh.verts[j] = make_shared<vertex>();
            aiVector3D pos = amesh->mVertices[j];
            aiVector3D norm = amesh->mNormals[j];
            aiVector3D *tex = amesh->mTextureCoords[j];
            mesh.verts[j]->position = Vector3f(pos.x, pos.y, pos.z);
            mesh.verts[j]->normal = Vector3f(norm.x, norm.y, norm.z);
            int numtexchan = amesh->GetNumUVChannels();
            mesh.verts[j]->texcoords.resize(numtexchan);
            unsigned int *numcomp = amesh->mNumUVComponents;
            for (int k = 0; k < numtexchan; ++k) {
                mesh.verts[j]->texcoords[k] = VectorXf(numcomp[k]);
                for (int l = 0; l < numcomp[k]; ++l) {
                    mesh.verts[j]->texcoords[k](l) = amesh->mTextureCoords[k][j][l];
                }
            }
            db.persist(*mesh.verts[j]);
        }
        mesh.idx.resize(amesh->mNumFaces);
        for (int j = 0; j < amesh->mNumFaces; ++j) {
            for (int k = 0; k < amesh->mFaces[j].mNumIndices; ++k) {
                mesh.idx.push_back(amesh->mFaces[j].mIndices[k]);
            }
        }
        unsigned int id = db.persist(mesh);
        result.push_back(id);
    }
    t.commit();
    return result;

}

void import_textures(const aiScene *scene, odb::database &db) {
    odb::transaction t(db.begin());

    for (int i = 0; i < scene->mNumTextures; ++i) {
        aiTexture *atex = scene->mTextures[i];
        texture tex;
        tex.height = atex->mHeight;
        tex.width = atex->mWidth;

        if (tex.height == 0) {
            tex.data.resize(tex.width);
            memmove(tex.data.data(), atex->pcData, tex.width);
        } else {
            tex.data.resize(tex.width * tex.height * sizeof(aiTexel));
            memmove(tex.data.data(), atex->pcData, tex.height * tex.width * sizeof(aiTexel));
        }

        db.persist(tex);
    }
    t.commit();
}
graph_node create_node(const aiNode* node, shared_ptr<graph_node> parent) {
    graph_node result;
    aiVector3D scale;
    aiVector3D trans;
    aiQuaternion rot;
    node->mTransformation.Decompose(scale, rot, trans);
    result.position = Eigen::Vector3f(trans.x, trans.y, trans.z);
    result.rotation = Eigen::Quaternionf(rot.w, rot.x, rot.y, rot.z);
    result.scale = Eigen::Vector3f(scale.x, scale.y, scale.z);
    result.name = node->mName.C_Str();
    result.parent = parent;
    return result;
}
void import_nodes(const aiScene *scene, odb::database& db, const vector<unsigned int>& mesh_ids) {
    odb::transaction t(db.begin());


    aiNode* acur_node = scene->mRootNode;
    auto root_node = make_shared<graph_node>(create_node(acur_node, nullptr));
    queue<pair<aiNode*, shared_ptr<graph_node> > > nodes;
    nodes.push(make_pair(scene->mRootNode, root_node));
    while(!nodes.empty()) {
        aiNode* anode;
        shared_ptr<graph_node> node;
        tie(anode, node) = nodes.front();
        db.persist(*node);
        nodes.pop();
        for(int i = 0; i < anode->mNumChildren; ++i) {
            auto achild = anode->mChildren[i];
            auto child = make_shared<graph_node>(create_node(anode, node));
            nodes.push(make_pair(achild, child));
        }
    }
    t.commit();

}

void import_assets(const string &filename, odb::database &db) {
    using namespace Assimp;
    Importer importer;
    const aiScene *scene = importer.ReadFile(filename.c_str(), aiProcessPreset_TargetRealtime_Quality);

    if (!scene) {
        throw runtime_error(importer.GetErrorString());
    }

    auto mesh_ids = import_meshes(scene, db);
    import_textures(scene, db);
    import_nodes(scene,db, mesh_ids);

}
}