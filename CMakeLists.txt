cmake_minimum_required(VERSION 3.10)

# exporting
# D_TYPE_LIBRARY_ROOT
# D_TYPE_INCLUDE
# D_TYPE_LIBS
# D_TYPE_EXTRA_DEPS
option(D_TYPE_IMPORT_SHARED "import shared " ON)

if(NOT DEFINED CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

set(D_TYPE_LIBRARY_ROOT ${CMAKE_CURRENT_LIST_DIR}/engine/libs)
set(D_TYPE_INCLUDE
    ${CMAKE_CURRENT_LIST_DIR}/includes
    ${CMAKE_CURRENT_LIST_DIR}/includes/core
    ${CMAKE_CURRENT_LIST_DIR}/includes/core-cpp
)
set(D_TYPE_VER 8.2.1)

if("${CMAKE_HOST_SYSTEM_NAME}" MATCHES "Windows")
    set(Windows ON)

    if(D_TYPE_IMPORT_SHARED)
        set(D_TYPE_LIBRARY_ROOT ${D_TYPE_LIBRARY_ROOT}/x64-win_64-dll)
    else()
        set(D_TYPE_LIBRARY_ROOT ${D_TYPE_LIBRARY_ROOT}/x64-win_64-static/msvc15-mt)
    endif()

    set(D_TYPE_INCLUDE "${D_TYPE_INCLUDE};${CMAKE_CURRENT_LIST_DIR}/includes/utils/dtwindow/win")
elseif("${CMAKE_HOST_SYSTEM_NAME}" MATCHES "Linux")
    set(Linux ON)

    if(D_TYPE_IMPORT_SHARED)
        set(D_TYPE_LIBRARY_ROOT ${D_TYPE_LIBRARY_ROOT}/x64-linux_64-shared)
    else()
        set(D_TYPE_LIBRARY_ROOT ${D_TYPE_LIBRARY_ROOT}/x64-linux_64-static/gcc)
    endif()

    set(D_TYPE_INCLUDE "${D_TYPE_INCLUDE};${CMAKE_CURRENT_LIST_DIR}/includes/utils/dtwindow/unix")
    set(D_TYPE_EXTRA_DEPS X11)
elseif("${CMAKE_HOST_SYSTEM_NAME}" MATCHES "MAC")
    set(MAC ON)
endif()

set(_D_TYPE_LIBS aux lay pwr txt std)
set(D_TYPE_LIBS)

foreach(DLIB ${_D_TYPE_LIBS})
    if(Windows)
        if(NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Release")
            message(FATAL_ERROR "d_type libs is built in release, if you wonna use this, you should use Release instead of [${CMAKE_BUILD_TYPE}]")
        endif()

        if(D_TYPE_IMPORT_SHARED)
            add_library(d_type_${DLIB} SHARED IMPORTED GLOBAL)
            set_target_properties(d_type_${DLIB} PROPERTIES
                IMPORTED_LOCATION "${D_TYPE_LIBRARY_ROOT}/dtype${DLIB}.dll"
                IMPORTED_IMPLIB "${D_TYPE_LIBRARY_ROOT}/dtype${DLIB}.lib")
        else()
            find_library(${DLIB}_path NAMES "dtype${DLIB}_lib-mt.lib" PATHS "${D_TYPE_LIBRARY_ROOT}" NO_DEFAULT_PATH)
            add_library(d_type_${DLIB} STATIC IMPORTED GLOBAL)
            set_property(TARGET d_type_${DLIB} PROPERTY
                IMPORTED_LOCATION ${${DLIB}_path})
        endif()
    else()
        if(D_TYPE_IMPORT_SHARED)
            add_library(d_type_${DLIB} SHARED IMPORTED GLOBAL)
            find_library(${DLIB}_path "libdtype${DLIB}.so.${D_TYPE_VER}" REQUIRED PATHS "${D_TYPE_LIBRARY_ROOT}" NO_DEFAULT_PATH)
            set_property(TARGET d_type_${DLIB} PROPERTY
                IMPORTED_LOCATION ${${DLIB}_path})
        else()
            find_library(${DLIB}_path NAMES "dtype${DLIB}.a" "dtype${DLIB}.o" PATHS "${D_TYPE_LIBRARY_ROOT}" NO_DEFAULT_PATH)
            print(${DLIB}_path)

            if(NOT "${${DLIB}_path}" MATCHES "${DLIB}_path-NOTFOUND")
                add_library(d_type_${DLIB} STATIC IMPORTED GLOBAL)
                set_property(TARGET d_type_${DLIB} PROPERTY
                    IMPORTED_LOCATION ${${DLIB}_path})
            else()
                set(${DLIB}_path "${D_TYPE_LIBRARY_ROOT}/dtype${DLIB}.o")
                add_library(d_type_${DLIB} OBJECT IMPORTED GLOBAL)
                set_property(TARGET d_type_${DLIB} PROPERTY
                    IMPORTED_OBJECTS ${${DLIB}_path})
            endif()
        endif()
    endif()

    target_include_directories(d_type_${DLIB} INTERFACE ${D_TYPE_INCLUDE})

    # set_target_properties(d_type_${DLIB} PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${D_TYPE_INCLUDE})
    add_library(D_Type::${DLIB} ALIAS d_type_${DLIB})
    set(D_TYPE_LIBS ${D_TYPE_LIBS} D_Type::${DLIB})
    set(D_TYPE_LIBS_RAW_NAME ${D_TYPE_LIBS_RAW_NAME} d_type_${DLIB})
    message("  DLIB:${DLIB} path:${${DLIB}_path}")
endforeach()

get_target_property(inc d_type_txt INTERFACE_INCLUDE_DIRECTORIES)

print(CMAKE_HOST_SYSTEM_NAME D_TYPE_LIBS D_TYPE_INCLUDE inc)

#   auto copy d_type*.dll to target path
if(Windows AND D_TYPE_IMPORT_SHARED)
    foreach(DLIB ${D_TYPE_LIBS})
        get_target_property(${DLIB}_POS ${DLIB} IMPORTED_LOCATION)
        set(DLIB_POSS ${DLIB_POSS} ${${DLIB}_POS})
    endforeach()

    # string(REGEX REPLACE "${D_TYPE_LIBRARY_ROOT}" "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}" DLIB_TARGET_POSS ${DLIB_POSS})
    add_custom_target(
        COPY_DLIBS
        COMMAND ${CMAKE_COMMAND} -E copy
        ${DLIB_POSS}
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )

    foreach(DLIB ${D_TYPE_LIBS_RAW_NAME})
        add_dependencies(${DLIB} COPY_DLIBS)
    endforeach()
endif()

set(D_TYPE_LIBRARY_ROOT ${D_TYPE_LIBRARY_ROOT} PARENT_SCOPE)
set(D_TYPE_INCLUDE ${D_TYPE_INCLUDE} PARENT_SCOPE)
set(D_TYPE_LIBS ${D_TYPE_LIBS} PARENT_SCOPE)
set(D_TYPE_EXTRA_DEPS ${D_TYPE_EXTRA_DEPS} PARENT_SCOPE)
set(D_TYPE_LIBS ${D_TYPE_LIBS} PARENT_SCOPE)