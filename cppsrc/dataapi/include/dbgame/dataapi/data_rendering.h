//
// Created by charlie on 9/15/16.
//

#pragma once
#include <odb/core.hxx>
#include <Eigen/Core>
#include <Eigen/Geometry>
#include <vector>
#include <memory>
#include <memory>
//#include "spatial_traits.h"
#pragma db value(Eigen::Vector3f) type("blob")
#pragma db value(Eigen::VectorXf) type("blob")
#pragma db value(Eigen::Quaternionf) type("blob")
//#pragma db member(Eigen::Vector3f::x) virtual(float)
//#pragma db member(Eigen::Vector3f::y) virtual(float)
//#pragma db member(Eigen::Vector3f::z) virtual(float)
namespace dbgame {
namespace data {
#pragma db object table("rendering_vertex")
class vertex {
public:
    Eigen::Vector3f position;
    Eigen::Vector3f normal;
    std::vector<Eigen::VectorXf> texcoords;
private:
    friend class odb::access;

    #pragma db id auto
    unsigned int id;
};


/**
 * \name mesh
 * \brief Database representation of a mash
 * 
 * the mesh object represents the high level mesh representation
 * that's stored in the database.
 */
#pragma db object table("rendering_mesh") session
class mesh {
public:
    /** list of vertices in the mesh */
	std::vector<std::shared_ptr<vertex>> verts;
    /** list of mesh indices, this should be in triangle format */
	std::vector<unsigned int> idx;
private:
	friend class odb::access;

	#pragma db id auto
	unsigned int id;
};

#pragma db object table("rendering_texture")
class texture {
public:
    int width;
    int height;

    #pragma db type("blob")
    std::vector<unsigned char> data;
private:
    friend class odb::access;

    #pragma db id auto
    unsigned int id;
};

#pragma db object table("rendering_graph_node")
class graph_node {
public:
    std::string name;
    Eigen::Vector3f position;
    Eigen::Vector3f scale;
    Eigen::Quaternionf rotation;
    #pragma db null
    std::shared_ptr<graph_node> parent;

private:
    friend class odb::access;
    #pragma db id auto
    unsigned int id;
};

#pragma db object table("rendering_graph_node_meshes")
class graph_meshes {
public:
    std::shared_ptr<graph_node> node;
    std::shared_ptr<graph_node> mesh;
private:
    friend class odb::access;

    #pragma db id auto
    unsigned int id;
};
}
}
