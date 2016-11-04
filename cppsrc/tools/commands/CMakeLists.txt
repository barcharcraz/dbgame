project(dbgame_tools_commands VERSION 0.1 LANGUAGES CXX)
find_package(gflags REQUIRED shared)
add_executable(import_assets_command import_assets_cmd.cpp)
target_link_libraries(import_assets_command gflags_shared tools dataapi)