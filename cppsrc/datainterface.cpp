#include "datainterface.h"
#include <sqlite3.h>
#include <ponder/class.hpp>
#include <string>
PONDER_TYPE(sqlite3_value*);
using namespace ponder;
using namespace std;
namespace dbgame
{
UserObject load_row_impl(sqlite3_stmt* stm, const Class& cls)
{
	UserObject result = cls.create();

	int count = sqlite3_column_count(stm);
	for (int i = 0; i < count; ++i)
	{
		string name = sqlite3_column_name(stm, i);
		if (!cls.hasProperty(name)) continue;
		const Property& prop = cls.property(name);
		prop.set(result, sqlite3_column_value(stm, i));
	}
	return result;
}

void store_row_impl(sqlite3_stmt* stm, const UserObject& obj)
{
	const Class& cls = obj.getClass();
	for(auto&& prop : cls.propertyIterator())
	{
		string name = prop.name();
		int idx = sqlite3_bind_parameter_index(stm, name.c_str());
		
	}
}
}
