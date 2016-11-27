
cmake_minimum_required(VERSION 3.5)
project(dbgame_tools VERSION 0.1 LANGUAGES CXX)
set(USE_FBX OFF CACHE BOOL "Use the FBX library")
find_package(Sqlite3 REQUIRED)
find_package(odb REQUIRED)
find_package(glbinding REQUIRED)
find_package(Assimp REQUIRED)


set(tools_src import_shaders.cpp import_shaders.h import_assets.cpp import_assets.h)
if(USE_FBX)
    find_package(FBX REQUIRED)
    set(tools_src ${tools_src} fbx_import_assets.cpp)
endif()
add_library(tools ${tools_src})
target_link_libraries(tools PUBLIC dataapi
        ${ODB_LIBRARIES}
        ${ASSIMP_LIBRARY}
        ${FBX_LIBRARIES})
target_include_directories(tools
        PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        PRIVATE ${ODB_INCLUDE_DIRS} ${ASSIMP_INCLUDE_DIRS}
        ${FBX_INCLUDE_DIRS})

add_subdirectory(commands)
