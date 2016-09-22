//
// Created by barch on 9/17/2016.
//
#pragma once
#include <geos/geom/Geometry.h>
#include <odb/traits.hxx>
#include <odb/sqlite/traits.hxx>
#include <Eigen/Core>
namespace odb {
    namespace sqlite {
        template<>
        struct value_traits<geos::geom::Geometry*, id_blob> {
            typedef geos::geom::Geometry* value_type;
            typedef details::buffer image_type;
            typedef value_type query_type;

            static void set_image(details::buffer& b,
                                  size_t& n,
                                  bool& is_null,
                                  const value_type& v);

            static void set_value(value_type& v,
                                  const details::buffer& b,
                                  size_t n,
                                  bool is_null);

        };

        template<>
        struct value_traits<Eigen::Vector3f, id_blob> {
            typedef Eigen::Vector3f value_type;
            typedef details::buffer image_type;
            typedef value_type query_type;

            static void set_image(image_type &b,
                                  size_t &n,
                                  bool &is_null,
                                  const value_type &v);

            static void set_value(value_type &v,
                                  const details::buffer &b,
                                  size_t n,
                                  bool is_null);

        };
    }
}