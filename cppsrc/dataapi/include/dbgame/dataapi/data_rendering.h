//
// Created by charlie on 9/15/16.
//

#pragma once
#include <odb/core.hxx>
#include <Eigen/Eigen>

#pragma db value(Eigen::Vector3f)
#pragma db member(Eigen::Vector3f::x) virtual(float)
#pragma db member(Eigen::Vector3f::y) virtual(float)
#pragma db member(Eigen::Vector3f::z) virtual(float)

#pragma db object table("rendering_vertex")
class vertex {
public:
    Eigen::Vector3f position;
    Eigen::Vector3f normal;
    Eigen::Vector3f texcoord;
private:
    friend class odb::access;

    #pragma db id auto
    unsigned int id;
};