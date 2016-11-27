#
# This module defines the following variables:
#
#   ODB_USE_FILE - Path to the UseODB.cmake file. Use it to include the ODB use file.
#                  The use file defines the needed functionality to compile and use
#                  odb generated headers.
#
#   ODB_FOUND - All required components and the core library were found
#   ODB_INCLUDR_DIRS - Combined list of all components include dirs
#   ODB_LIBRARIES - Combined list of all componenets libraries
#
#   ODB_LIBODB_FOUND - Libodb core library was found
#   ODB_LIBODB_INCLUDE_DIRS - Include dirs for libodb core library
#   ODB_LIBODB_LIBRARIES - Libraries for libodb core library
#
# For each requested component the following variables are defined:
#
#   ODB_<component>_FOUND - The component was found
#   ODB_<component>_INCLUDE_DIRS - The components include dirs
#   ODB_<component>_LIBRARIES - The components libraries
#
# <component> is the original or uppercase name of the component
#
# The component names relate directly to the odb module names.
# So for the libodb-mysql.so library, the component is named mysql,
# for the libodb-qt.so module it's qt, and so on.
#

set(ODB_USE_FILE "${CMAKE_CURRENT_LIST_DIR}/UseODB.cmake")

#find_package(odb COMPONENTS ${odb_FIND_COMPONENTS} CONFIG)
function(find_odb_api component)
	string(TOUPPER "${component}" component_u)
	set(ODB_${component_u}_FOUND FALSE PARENT_SCOPE)

	pkg_check_modules(PC_ODB_${component} QUIET "libodb-${component}")

	find_path(ODB_${component}_INCLUDE_DIR
			NAMES odb/${component}/version.hxx
			HINTS
			/usr/local
			/include
			/usr/include
			${ODB_LIBODB_INCLUDE_DIRS}
			${PC_ODB_${component}_INCLUDE_DIRS})

	find_library(ODB_${component}_LIBRARY
			NAMES odb-${component} libodb-${component}
			HINTS
			/usr/local
			/lib
			/usr/lib
			${ODB_LIBRARY_PATH}
			${PC_ODB_${component}_LIBRARY_DIRS})
	message(INFO ${component})
	mark_as_advanced(ODB_${component}_INCLUDE_DIR ODB_${component}_LIBRARY)

	if(ODB_${component_u}_INCLUDE_DIRS AND ODB_${component_u}_LIBRARIES)
		set(ODB_${component_u}_FOUND TRUE PARENT_SCOPE)
		set(ODB_${component}_FOUND TRUE PARENT_SCOPE)

		list(APPEND ODB_INCLUDE_DIRS ${ODB_${component_u}_INCLUDE_DIRS})
		list(REMOVE_DUPLICATES ODB_INCLUDE_DIRS)
		set(ODB_INCLUDE_DIRS ${ODB_INCLUDE_DIRS} PARENT_SCOPE)

		list(APPEND ODB_LIBRARIES ${ODB_${component_u}_LIBRARIES})
		list(REMOVE_DUPLICATES ODB_LIBRARIES)
		set(ODB_LIBRARIES ${ODB_LIBRARIES} PARENT_SCOPE)
	endif()
endfunction()
find_program(odb_BIN
		NAMES odb
		HINTS
		${libodb_INCLUDE_DIR}/../bin)
set(ODB_EXECUTABLE ${odb_BIN} CACHE STRING "ODB executable")
find_package(odb NO_MODULE COMPONENTS ${odb_FIND_COMPONENTS} QUIET)
if(NOT odb_FOUND)
	find_package(PkgConfig)
    pkg_check_modules(PC_LIBODB "libodb")
	message(INFO "ODB NOT FOUND")


#set(ODB_LIBRARY_PATH "" CACHE STRING "Common library search hint for all ODB libs")

    find_path(ODB_libodb_INCLUDE_DIR
            NAMES odb/version.hxx
            HINTS
            ${PC_LIBODB_INCLUDE_DIRS}
            /usr/include)

    find_library(ODB_libodb_LIBRARY
            NAMES odb libodb
            HINTS
            /usr/local
            /usr/lib
            /usr/lib/odb
            /lib/odb
            /usr/local/lib/odb
            ${ODB_LIBRARY_PATH}
    )

    if(NOT TARGET odb::libodb)
        add_library(odb::libodb UNKNOWN IMPORTED)
        message(${ODB_libodb_INCLUDE_DIR})
        message(${ODB_libodb_LIBRARY})
    endif()
    set_target_properties(odb::libodb PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES ${ODB_libodb_INCLUDE_DIR}
            IMPORTED_LOCATION ${ODB_libodb_LIBRARY})
    
    foreach(component ${odb_FIND_COMPONENTS})
        find_odb_api(${component})
        if(NOT TARGET odb::libodb-${component})
            add_library(odb::libodb-${component} UNKNOWN IMPORTED)
        endif()
        set_target_properties(odb::libodb-${component} PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES ${ODB_${component}_INCLUDE_DIR}
                IMPORTED_LOCATION ${ODB_${component}_LIBRARY})

    endforeach()
	include(FindPackageHandleStandardArgs)
	find_package_handle_standard_args(odb DEFAULT_MSG ODB_libodb_LIBRARY ODB_libodb_INCLUDE_DIR)
endif()
