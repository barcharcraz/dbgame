
#include <import_shaders.h>
#include <gflags/gflags.h>
#include <dbgame/dataapi.h>
#include <cstdio>
#include <odb/sqlite/database.hxx>
#include <odb/core.hxx>
#include <experimental/filesystem>
#include <vector>
DEFINE_string(db, "", "the database to write to");
DEFINE_string(in, "", "the shader file or directory");
namespace fs = std::experimental::filesystem;
int main(int argc, char** argv) {
    using namespace dbgame;
    gflags::ParseCommandLineFlags(&argc, &argv, true);
    odb::sqlite::database db(FLAGS_db, SQLITE_OPEN_READWRITE);
    fs::path p(FLAGS_in);
    std::vector<data::shader> shaders;
    fprintf(stdout, "Loading Shaders ...\n");
    if(fs::is_directory(p)) {
        shaders = dbgame::load_shader_directory(p.generic_u8string());
    } else {
        shaders = dbgame::load_shader_directory(p.generic_u8string());
    }
    fprintf(stdout, "Writing Shaders to database ...\n");
    odb::transaction t(db.begin());
    for(auto& shader in shaders) {
        fprintf("
    }
    
}
