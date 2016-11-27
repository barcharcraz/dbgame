//
// Created by barch on 10/1/2016.
//

#include "import_assets.h"
#include <gflags/gflags.h>
#include "import_assets.h"
#include <odb/sqlite/database.hxx>
#include <odb/core.hxx>
#include <odb/schema-catalog.hxx>
DEFINE_string(db, "", "the database to write to");
DEFINE_string(in, "", "the input asset");
int main(int argc, char** argv) {
    gflags::ParseCommandLineFlags(&argc, &argv, true);
    odb::sqlite::database db(FLAGS_db, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE);
    odb::transaction t(db.begin());
    odb::schema_catalog::create_schema(db);
    t.commit();
    dbgame::import_assets(FLAGS_in, db);
}
