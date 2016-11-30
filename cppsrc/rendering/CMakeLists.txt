project(rendering VERSION 0.1 LANGUAGES CXX)
find_package(odb REQUIRED COMPONENTS sqlite)
find_package(Eigen3 REQUIRED)
find_package(glbinding REQUIRED)
include(${ODB_USE_FILE})
set(rendering_src
        src/glrenderer.cpp
		src/gldata.h
		src/glshaders.cpp
        )
set(rendering_odb_src
        src/gldata.h
        )
set(rendering_h
    include/dbgame/rendering/glrenderer.h
    include/dbgame/rendering/glshaders.h)
get_target_property(dataapi_include_dirs dataapi INCLUDE_DIRECTORIES)
#string(REPLACE ";" " " dataapi_include_dirs "${dataapi_include_dirs}")
odb_compile(rendering_src FILES ${rendering_odb_src} DB sqlite GENERATE_QUERY GENERATE_SCHEMA
        STANDARD c++14
        #RELTO ${CMAKE_CURRENT_SOURCE_DIR}
        INCLUDE ${CMAKE_CURRENT_SOURCE_DIR}/src
                ${dataapi_include_dirs}
                ${EIGEN3_INCLUDE_DIR}
        )

add_library(rendering ${rendering_src} ${rendering_h})
add_library(dbgame::rendering ALIAS rendering)
target_link_libraries(rendering PRIVATE ${ODB_LIBRARIES}
        glbinding::glbinding dataapi

        )
set_target_properties(rendering PROPERTIES CXX_STANDARD 14)

target_include_directories(rendering PRIVATE ${EIGEN3_INCLUDE_DIR}
        ${ODB_COMPILE_OUTPUT_DIR} ${ODB_INCLUDES} ${CMAKE_CURRENT_SOURCE_DIR}/src
        include/dbgame/rendering/
        INTERFACE
            $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
            $<INSTALL_INTERFACE:include>
)
add_subdirectory(shaders)


install(TARGETS rendering EXPORT renderingConfig
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin)
    
install(DIRECTORY include/ DESTINATION include/dbgame/rendering/)
install(EXPORT renderingConfig DESTINATION share/dbgame/cmake NAMESPACE dbgame)
export(TARGETS rendering NAMESPACE dbgame FILE renderingConfig.cmake)
