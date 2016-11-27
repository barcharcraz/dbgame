project(datapai VERSION 0.1 LANGUAGES CXX)
find_package(Sqlite3 REQUIRED)
#find_package(ponder CONFIG REQUIRED)
find_package(Eigen3 REQUIRED)
find_package(odb REQUIRED COMPONENTS sqlite libodb)
find_package(glbinding REQUIRED)
find_package(GEOS REQUIRED)
include(${ODB_USE_FILE})


set(dataapi_h
        include/dbgame/dataapi/data_opengl.h
        include/dbgame/dataapi/data_rendering.h
    )
set(dataapi_src src/spatial_traits.cpp
        include/dbgame/dataapi/data_opengl.h
        include/dbgame/dataapi/data_rendering.h
        include/dbgame/dataapi/spatial_traits.h include/dbgame/dataapi/traits.h src/prologue.h src/epilogue.h)

odb_compile(dataapi_src FILES ${dataapi_h} DB sqlite GENERATE_QUERY GENERATE_SCHEMA
    STANDARD c++14
        HEADER_PROLOGUE src/prologue.h
        HEADER_EPILOGUE src/epilogue.h
        SOURCE_PROLOGUE src/prologue.h
        SOURCE_EPILOGUE src/epilogue.h
    RELTO ${CMAKE_CURRENT_SOURCE_DIR}/include
    INCLUDE ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${EIGEN3_INCLUDE_DIR}
        ${SQLITE3_INCLUDE_DIRS})
add_library(dataapi ${dataapi_src} include/dbgame/dataapi.h)
if(MSVC)
target_compile_options(dataapi PUBLIC /wd4068)
endif()
target_include_directories(dataapi PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${ODB_COMPILE_OUTPUT_DIR}>
    $<INSTALL_INTERFACE:include>
        ${EIGEN3_INCLUDE_DIR}
        ${SQLITE3_INCLUDE_DIRS}
    PRIVATE src
        ${GEOS_INCLUDE_DIR})
target_link_libraries(dataapi PRIVATE odb::libodb-sqlite odb::libodb glbinding::glbinding
        ${GEOS_LIBRARY})

        
install(TARGETS dataapi EXPORT dataapiConfig
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin)
install(DIRECTORY include/ DESTINATION include)
install(DIRECTORY ${ODB_COMPILE_OUTPUT_DIR}/ DESTINATION include)
install(EXPORT dataapiConfig DESTINATION share/dbgame/cmake)
export(TARGETS dataapi NAMESPACE dbgame FILE dataapiConfig.cmake)
