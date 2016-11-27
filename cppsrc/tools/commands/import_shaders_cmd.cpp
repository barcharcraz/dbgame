
#include <import_shaders.h>
#include <gflags/gflags.h>
#include <odb/sqlite/database.hxx>
#include <odb/core.hxx>
#include <experimental/filesystem>
DEFINE_string(db, "", "the database to write to");
DEFINE_string(in, "", "the shader file or directory");
namespace fs = std::experimental::filesystem;
int main(int argc, char** argv) {
    gflags::ParseCommandLineFlags(&argc, &argv, true);
    odb::sqlite::database db(FLAGS_db, SQLITE_OPEN_READWRITE);
    fs::path p(FLAGS_in);
    if(fs::is_directory(p)) {
        
        dbgame::load_shader_directory(p.generic_u8string());
    } else {
        dbgame::load_shader_directory(p.generic_u8string());
    }
}
