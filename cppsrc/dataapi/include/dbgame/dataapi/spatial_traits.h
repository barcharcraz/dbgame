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
        template<typename T, int O>
        struct value_traits<Eigen::Quaternion<T, O>, id_blob > {
            typedef Eigen::Quaternion<T, O> value_type;
            typedef details::buffer image_type;
            typedef value_type query_type;

            static void set_image(image_type &b,
                                  size_t& n,
                                  bool& is_null,
                                  const value_type& v)
            {
                is_null = false;
                n = sizeof(v);
                b.capacity(n);
                memmove(b.data(), &v, sizeof(v));
            }

            static void set_value(value_type& v,
                                  const details::buffer& b,
                                  size_t n,
                                  bool is_null)
            {
                if(is_null) {
                    v = Eigen::Quaternion<T,O>::Identity();
                    return;
                }
                assert(n == sizeof(v));
                memmove(&v, b.data(), n);
            }
        };
        template<typename T, int R, int C, int O, int MR, int MC>
        struct value_traits<Eigen::Matrix<T,R,C,O,MR,MC>, id_blob> {
            typedef Eigen::Matrix<T,R,C,O,MR,MC> value_type;
            typedef details::buffer image_type;
            typedef value_type query_type;

            static void set_image(image_type &b,
                                  size_t& n,
                                  bool& is_null,
                                  const value_type& v)
            {
                is_null = false;
                n = v.size()*sizeof(T);
                b.capacity(n);
                memmove(b.data(), v.data(), n);
            }

            static void set_value(value_type& v,
                                  const details::buffer& b,
                                  size_t n,
                                  bool is_null)
            {
                if(is_null) {
                    v = Eigen::Matrix<T,R,C,O,MR,MC>{};
                    return;
                }
                long long int sz = n / sizeof(T);
                v = Eigen::Matrix<T,R,C,O,MR,MC>{sz};
                memmove(v.data(), b.data(), n);
            }
        };
    }
}