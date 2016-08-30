#ifndef DBGAME_DATAINTERFACE_H
#define DBGAME_DATAINTERFACE_H
#include <ponder/class.hpp>

struct sqlite3_stmt;
struct sqlite3_value;
namespace dbgame
{
	template<typename T>
	struct ValueConverter
	{
		static void bind(sqlite3_stmt& stm, int col, const T& obj);
		static T read(sqlite3_value* val);
	};
	ponder::UserObject load_row_impl(sqlite3_stmt* stm, const ponder::Class& cls);
	void store_row_impl(sqlite3_stmt* stm, const ponder::UserObject& obj);

	template<typename T>
	T load_row(sqlite3_stmt* stm)
	{
		auto result = load_row_impl(stm);
		return *static_cast<T*>(result.pointer());
	}
	template<typename T>
	void store_row(sqlite3_stmt* stm, const T& obj)
	{
		store_row_impl(stm, ponder::UserObject::ref(obj));
	}

}


#endif