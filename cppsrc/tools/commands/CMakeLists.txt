project(dbgame_tools_commands VERSION 0.1 LANGUAGES CXX)
find_package(gflags REQUIRED shared)
add_executable(import_assets_command import_assets_cmd.cpp)
target_link_libraries(import_assets_command PRIVATE gflags-shared tools dataapi)

add_executable(import_shaders_command import_shaders_cmd.cpp)
target_link_libraries(import_shaders_command PRIVATE gflags-shared tools dataapi dbgame::rendering stdc++fs)
