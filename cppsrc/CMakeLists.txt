cmake_minimum_required(VERSION 3.5)
project(dbgame VERSION 0.1 LANGUAGES CXX)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")
find_package(Sqlite3 REQUIRED)
#find_package(ponder CONFIG REQUIRED)
find_package(Boost REQUIRED)
find_package(Eigen3 REQUIRED)
find_package(ODB REQUIRED COMPONENTS sqlite libodb)
find_package(glbinding REQUIRED)
include(${ODB_USE_FILE})
set(dbgame_src
    main.cpp
    glrender.cpp
)
set(dbgame_h
    data_opengl.h
)
add_executable(dbgame
    ${dbgame_src}
)
set_property(TARGET dbgame PROPERTY CXX_STANDARD 14)
target_include_directories(dbgame PRIVATE 
    ${SQLITE3_INCLUDE_DIRS} 
    ${EIGEN3_INCLUDE_DIR}
    ${ODB_COMPILE_OUTPUT_DIR})
target_link_libraries(dbgame ${SQLITE3_LIBRARIES}
                             odb::libodb
                             odb::libodb-sqlite
                             glbinding::glbinding
                             dataapi)

add_subdirectory(tools)
add_subdirectory(dataapi)
add_subdirectory(rendering)
add_subdirectory(tests)
