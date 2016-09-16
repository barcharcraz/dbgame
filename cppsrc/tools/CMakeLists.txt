
cmake_minimum_required(VERSION 3.5)
project(dbgame_tools VERSION 0.1 LANGUAGES CXX)
find_package(Sqlite3 REQUIRED)
find_package(ODB REQUIRED)
find_package(glbinding REQUIRED)
find_package(Boost REQUIRED COMPONENTS program_options filesystem)

add_library(import_shaders import_shaders.h import_shaders.cpp)
target_link_libraries(import_shaders dataapi Boost::filesystem
        ${ODB_LIBRARIES})
target_include_directories(import_shaders PRIVATE ${ODB_INCLUDE_DIRS})
add_executable(dbgt dbgt.cpp)
target_link_libraries(dbgt import_shaders Boost::program_options
        ${ODB_LIBRARIES} ${SQLITE3_LIBRARIES})
target_include_directories(dbgt PRIVATE ${ODB_INCLUDE_DIRS} ${SQLITE3_INCLUDE_DIRS})


