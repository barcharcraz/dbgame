cmake_minimum_required(VERSION 3.5)
project(dbgame VERSION 0.1 LANGUAGES CXX)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")
find_package(Sqlite3 REQUIRED)
find_package(ponder CONFIG REQUIRED)
find_package(Boost REQUIRED)
find_package(Eigen3 REQUIRED)
add_executable(dbgame
    main.cpp
    datainterface.h
    datainterface.cpp
)
target_include_directories(dbgame PRIVATE 
    ${SQLITE3_INCLUDE_DIRS} 
    ${EIGEN3_INCLUDE_DIR})
target_link_libraries(dbgame ${SQLITE3_LIBRARIES}
                             ponder::ponder)