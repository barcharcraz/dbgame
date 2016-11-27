#include "import_shaders.h"
#include "import_assets.h"
#include <dbgame/dataapi.h>
#include <iostream>
#include <string>
#include <memory>
#include <odb/database.hxx>
#include <odb/sqlite/database.hxx>
#include <odb/core.hxx>
#include <odb/schema-catalog.hxx>
#include <sqlite3.h>
#include <gflags/gflags.h>

using namespace std;
using namespace dbgame;
unique_ptr<odb::sqlite::database> open_sqlite(const string& file) {
    auto db = make_unique<odb::sqlite::database>(file, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE);
    odb::transaction t(db->begin());
    odb::schema_catalog::create_schema(*db);
    t.commit();
    return db;
}

int main(int argc, const char** argv) {
    options_description desc("tools for dbgame such as batch import-export");
    desc.add_options()
            ("help", "produce a help message")
            ("in", value<string>(), "directory to add files from")
            ("database", value<string>(), "database file to add to");
    positional_options_description pos;
    pos.add("command", 1).add("subargs", -1);
    variables_map vm;
    parsed_options parsed = command_line_parser(argc, argv).options(desc).positional(pos).allow_unregistered().run();
    store(parsed, vm);
    if(vm.count("help")) {
        cout << desc << endl;
        return 1;
    }
    auto cmd = vm["command"].as<string>();
    if(cmd == "import_shaders") {
        options_description import_shaders("import_shaders options");
        import_shaders.add_options()
                ("in", value<string>(), "directory to add files from")
                ("database", value<string>(), "database file to add to");
        vector<string> opts = collect_unrecognized(parsed.options, include_positional);
        opts.erase(opts.begin());
        store(command_line_parser(opts).options(import_shaders).run(), vm);
        auto db = open_sqlite(vm["database"].as<string>());
        vector<shader> shaders = load_shader_directory(vm["in"].as<string>());
        odb::transaction t(db->begin());
        for (shader &shader : shaders) {
            db->persist(shader);
        }
        t.commit();
    }
    if(cmd == "import_asset") {
        options_description import_assets_opts("import_assets_options");
        import_assets_opts.add_options()
                ("in", value<string>(), "asset to import")
                ("database", value<string>(), "database to import into");
        vector<string> opts = collect_unrecognized(parsed.options, include_positional);
        opts.erase(opts.begin());
        store(command_line_parser(opts).options(import_assets_opts).run(), vm);
        auto db = open_sqlite(vm["database"].as<string>());
        odb::transaction t(db->begin());
        import_assets(vm["in"].as<string>(), *db);
    }

    
}
