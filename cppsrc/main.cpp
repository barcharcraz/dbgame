
#include <sqlite3.h>
#include <tuple>
#include <string>
#include <system_error>
#include <exception>
#include <vector>
#include <cassert>
#include <ponder/pondertype.hpp>
#include <ponder/classbuilder.hpp>
#include <cstdio>
#include <functional>
#include <Eigen/Core>
#include <Eigen/Eigen>
#include <soci.h>
#include <sqlite3/soci-sqlite3.h>
using namespace std;
namespace detail
{
	template<class F, class Tuple, size_t... I>
	constexpr decltype(auto) apply_impl(F&& f, Tuple&& t, index_sequence<I...>)
	{
		return invoke(forward<F>(f), get<I>(forward<Tuple>(t))...);
	}
}
template<class F, class Tuple>
constexpr decltype(auto) apply(F&& f, Tuple&& t)
{
	return detail::apply_impl(forward<F>(f), forward<Tuple>(t),
		make_index_sequence<tuple_size_v<decay_t<Tuple>>>{});
}
/* DO NOT USE THIS CLASS IN YOUR CODE 
 * this is an internal class
*/
class dbvalue_helper
{
public:
	dbvalue_helper(const void* p, int size)
		: bytes(p), size(size) {}

	template<typename T>
	operator T() const
	{
		if(size != sizeof(T))
		{	
			
			throw runtime_error("Bad database cast, not the same size");
		}
		return *reinterpret_cast<T*>(bytes);
	}
private:
	const void* bytes;
	int size;
};
struct example_vector
{
	float x;
	float y;
	float z;
};
struct example_vector2
{
	float z;
	float x;
	float y;
};
struct example_table
{
	int id;
	int num;
	float fraction;
	Eigen::Vector2f vec;
};

PONDER_TYPE(example_vector)
PONDER_TYPE(example_table)

void declare()
{
	using namespace ponder;
	Class::declare<example_vector>("example_vector")
		.property("x", &example_vector::x)
		.property("y", &example_vector::y)
		.property("z", &example_vector::z);
	Class::declare<example_table>("example_table")
		.property("id", &example_table::id)
		.property("num", &example_table::num)
		.property("fraction", &example_table::fraction)
		.property("vec", &example_table::vec);
}
/*
template<typename T>
vector<T> query(sqlite3 *conn, const string& query)
{
	using namespace ponder;
	vector<T> result;
	sqlite3_stmt *stmt = nullptr;
	int hr = SQLITE_OK;
	hr = sqlite3_prepare_v2(conn, query.c_str(), -1, &stmt, nullptr);
	if (hr != SQLITE_OK) throw system_error(result, system_category());
	hr = sqlite3_step(stmt);
	int numcols = sqlite3_column_count(stmt);
	const Class& metaclass = classByType<T>();
	// TODO: make this code work with non-packed members
	while(hr == SQLITE_ROW)
	{
		T elm;
		UserObject obj = UserObject::ref(elm);
		char* mem = reinterpret_cast<char*>(&elm);
		for(int i = 0; i < numcols; ++i)
		{
			const void* bytes = sqlite3_column_blob(stmt, i);
			const int size = sqlite3_column_bytes(stmt, i);
			auto& prop = metaclass.property(i);
			obj.set(i, dbvalue_helper(bytes, size));
		}
		result.push_back(elm);
	}
	return result;
}

template<int i, typename Vec>
typename Vec::value_type get(const Vec& v)
{
	return v[i];
}
template<typename T, typename Args>
T make_value_type(Args a)
{
	return T(a...);
}
Eigen::Vector3f make_vector(float a, float b, float c)
{
	return Eigen::Vector3f(a, b, c);
}
*/

namespace soci
{
	template<>
	struct type_conversion<example_table>
	{
		typedef values base_type;
		static void from_base(const values& v, indicator ind, example_table& tbl)
		{
			tbl.id = v.get<int>("example_id");
			tbl.fraction = v.get<float>("fraction");
			tbl.num = v.get<int>("num");
			soci::blob blob = v.get<soci::blob>("vec");
			if(blob.get_len() != sizeof(tbl.vec))
			{
				throw soci::soci_error("Bad conversion to custom type");
			}
			blob.read(0, (char*)&tbl.vec, sizeof(tbl.vec));
		}
		static void to_base(const example_table& tbl, values& v, indicator& ind)
		{
			v.set("example_id", tbl.id);
			v.set("fraction", tbl.fraction);
			v.set("num", tbl.num);
			v.set("vec", tbl.vec);
		}
	};
	template<>
	struct type_conversion<Eigen::Vector3f>
	{
		typedef blob base_type;
		static void from_base(const blob& b, indicator ind, Eigen::Vector3f& vec)
		{
			
			b.read(0, (char*)&vec[0], sizeof(vec));
		}
	};
}
int main(int argc, char** argv)
{
	using namespace soci;
	session conn(soci::sqlite3, ":memory:");
	conn << "CREATE TABLE test_tbl AS ( "
		"id integer primary key, "
		"num integer, "
		"fraction real, "
		"vec blob);";
	example_vector v{ 1.0, 0.0, 1.0 };
	example_vector v2 = { 1.0, 0.0, 1.0 };
	dbvalue_helper test(&v, sizeof(v));
	Eigen::Vector3f test2;
	test2 = test;

	printf("%f, %f, %f\n", test2.x(), test2.y(), test2.z());
	char c[2];
	fgets(c, 2, stdin);

}
