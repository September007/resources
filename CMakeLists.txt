cmake_minimum_required(VERSION 3.10)
project(ffmpeg-cmake)

include(cmake/util.cmake)
include(cmake/ff_name_resolv.cmake)
option(ENABLE_FF_SHARED "whether or not to build shared ffmpeg" ON)
option(FF_TARGETS "which ff target will be build,default is all,availiable is avcodec avdevice avfilter avformat avutil postproc swresample swscale" "")
option(FF_PACK_ROOT "where to install the ffmpeg library and their headers" "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
    set(Windows ON)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Linux")
    set(Linux ON)
endif()

if(ENABLE_FF_SHARED)
    set(IF_ENABLE_FF_SHARED --enable-shared)
endif()

if("${FF_PACK_ROOT}" STREQUAL "" OR "${FF_PACK_ROOT}" STREQUAL "ON" OR "${FF_PACK_ROOT}" STREQUAL "OFF")
    set(FF_PACK_ROOT ${CMAKE_BINARY_DIR}/ffmpeg)
endif()

if("${FF_TARGETS}" STREQUAL "" OR "${FF_TARGETS}" STREQUAL "ON" OR "${FF_TARGETS}" STREQUAL "OFF")
    set(FF_TARGETS # targets
        avcodec
        avdevice
        avfilter
        avformat
        avutil
        postproc
        swresample
        swscale)
endif()

set(FFMPEG_CONFIGURE_OUTPUT
    "${CMAKE_CURRENT_LIST_DIR}/ffmpeg/config.h"
    "${CMAKE_CURRENT_LIST_DIR}/ffmpeg/config.asm"
    "${CMAKE_CURRENT_LIST_DIR}/ffmpeg/config_components.h")

print(CMAKE_RUNTIME_OUTPUT_DIRECTORY CMAKE_BINARY_DIR FFMPEG_CONFIGURE_OUTPUT)
include(cmake/configure.cmake)
add_custom_command(OUTPUT ${FFMPEG_CONFIGURE_OUTPUT}
    COMMAND ${CONFIG_COMMAND}
    DEPENDS "${CMAKE_CURRENT_LIST_DIR}/cmake/configure.cmake"
    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/ffmpeg"
)

add_custom_target(ff_configure
    DEPENDS ${FFMPEG_CONFIGURE_OUTPUT}
    VERBATIM
)

if(NOT IS_DIRECTORY "${FF_PACK_ROOT}/lib")
    file(MAKE_DIRECTORY "${FF_PACK_ROOT}/lib")
endif()

set(FF_LIB_VER 60)

foreach(FLIB ${FF_TARGETS})
    ff_name_resolve(${FLIB} ${CMAKE_BUILD_TYPE} SHARED ${FLIB}_NAME OFF)
    set(${FLIB}_MAKE_TARGET lib${FLIB}/${${FLIB}_NAME})

    set(${FLIB}_TARGET_LIBRARY ${FF_PACK_ROOT}/lib/${${FLIB}_NAME})
    add_custom_command(
        OUTPUT "${${FLIB}_TARGET_LIBRARY}"
        COMMAND "cp" "lib${FLIB}/${${FLIB}_NAME}*" "${FF_PACK_ROOT}/lib/"
        DEPENDS ff_configure "${CMAKE_CURRENT_LIST_DIR}/ffmpeg/lib${FLIB}/${${FLIB}_NAME}.${FF_LIB_VER}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/ffmpeg")

    add_custom_command(
        OUTPUT "${CMAKE_CURRENT_LIST_DIR}/ffmpeg/lib${FLIB}/${${FLIB}_NAME}.${FF_LIB_VER}"
        COMMAND "make" "${${FLIB}_MAKE_TARGET}" # this will check source file
        WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/ffmpeg")

    add_library(ffc_${FLIB} SHARED IMPORTED GLOBAL)
    set_target_properties(ffc_${FLIB} PROPERTIES
        IMPORTED_LOCATION "${${FLIB}_TARGET_LIBRARY}")
    add_library(ffc::${FLIB} ALIAS ffc_${FLIB})
    set(FF_MAKE_ALL ${FF_MAKE_ALL} ${${FLIB}_TARGET_LIBRARY})
    set(FF_OUTOUT_TARGETS ${FF_OUTOUT_TARGETS} ffc_${FLIB})

    # print(${FLIB}_MAKE_TARGET HINT FLIB_MAKE_TARGET)
endforeach()

add_custom_target(ff_makeall
    DEPENDS ${FF_MAKE_ALL}
    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/ffmpeg")


# target_include_directories(xx SYSTEM BEFORE PUBLIC ${CMAKE_CURRENT_LIST_DIR}/ffmpeg)
if(NOT "${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_LIST_DIR}")
    set(FF_OUTOUT_TARGETS ${FF_OUTOUT_TARGETS} PARENT_SCOPE)
endif()

print(FF_OUTOUT_TARGETS)