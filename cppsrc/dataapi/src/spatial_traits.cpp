//
// Created by charlie on 9/15/16.
//

/**
 * @brief Implements type traits for spatial types, converting them
 * to and from native formats. In general the type comes in as WKB and
 * GEOS is used to parse that.
 */

#include <geos.h>
#include <odb/core.hxx>
#include <odb/traits.hxx>
#include <odb/sqlite/traits.hxx>
#include <string>

using geos::geom::Geometry
namespace odb {
    namespace sqlite {
        template<>
        class value_traits<Geometry, id_blob> {

        };
    }
}