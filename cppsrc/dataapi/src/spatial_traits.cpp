//
// Created by charlie on 9/15/16.
//

/**
 * @brief Implements type traits for spatial types, converting them
 * to and from native formats. In general the type comes in as WKB and
 * GEOS is used to parse that.
 */

//#include <geos/geos.h>

#include <geos/geom/Geometry.h>
#include <geos/io/WKBWriter.h>
#include <geos/io/WKBReader.h>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#pragma GCC diagnostic ignored "-Wignored-attributes"
#include <odb/core.hxx>
#include <odb/traits.hxx>
#include <odb/sqlite/traits.hxx>

#include <Eigen/Core>

#pragma GCC diagnostic pop

#include <string>
#include <sstream>
#include "dbgame/dataapi/spatial_traits.h"
using geos::geom::Geometry;
using namespace odb::sqlite;
using namespace std;
using namespace Eigen;

namespace odb {
    namespace sqlite {


        void value_traits<Geometry *, id_blob>::set_image(details::buffer &b,
                                                          size_t &n,
                                                          bool &is_null,
                                                          const value_type &v) {
            using std::ostringstream;
            geos::io::WKBWriter writer;
            ostringstream o;
            writer.write(*v, o);
            auto s = o.str();
            n = s.length();
            if (n > b.capacity()) b.capacity(n);
            memmove(b.data(), s.c_str(), n);
        }

        void value_traits<Geometry *, id_blob>::set_value(value_type &v,
                                                          const details::buffer &b,
                                                          size_t n,
                                                          bool is_null) {
            if (is_null) return;
            using std::istringstream;
            using std::string;
            geos::io::WKBReader reader;
            string str(b.data(), n);
            istringstream stream(str);
            v = reader.read(stream);
        }

        void value_traits<Vector3f, id_blob>::set_image(image_type &b, size_t &n, bool &is_null, const value_type &v) {
            is_null = false;
            n = sizeof(Vector3f);
            b.capacity(n);
            memmove(b.data(), &v, n);
        }

        void
        value_traits<Vector3f, id_blob>::set_value(value_type &v, const details::buffer &b, size_t n, bool is_null) {
            if (is_null) {
                v = Vector3f(0, 0, 0);
                return;
            }
            assert(n == sizeof(Vector3f));
            memmove(&v, b.data(), sizeof(value_type));

        }

    }
}