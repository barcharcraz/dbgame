#include "import_shaders.h"
#include <dbgame/dataapi.h>
#include <boost/program_options.hpp>
#include <iostream>
#include <string>
#include <odb/database.hxx>
#include <odb/sqlite/database.hxx>
#include <odb/core.hxx>
#include <odb/schema-catalog.hxx>
#include <sqlite3.h>
using namespace std;
using namespace boost::program_options;
int main(int argc, const char** argv) {
    options_description desc("tools for dbgame such as batch import-export");
    desc.add_options()
            ("help", "produce a help message")
            ("in", value<string>(), "directory to add files from")
            ("database", value<string>(), "database file to add to");
    variables_map vm;
    store(parse_command_line(argc, argv, desc), vm);
    notify(vm);
    if(vm.count("help")) {
        cout << desc << endl;
        return 1;
    }

    if(!vm.count("in")) {
        cout << "Error: Need to set the input directory" << endl;
        return 1;
    }
    if(!vm.count("database")) {
        cout << "Error: Need to set the database path" << endl;
        return 1;
    }
    odb::sqlite::database db(vm["database"].as<string>(), SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE);
    odb::transaction t(db.begin());
    odb::schema_catalog::create_schema(db);
    t.commit();
    vector<shader> shaders = load_shader_directory(vm["in"].as<string>());
    t.reset(db.begin());
    for(shader& shader : shaders) {
        db.persist(shader);
    }
    t.commit();

    
}
