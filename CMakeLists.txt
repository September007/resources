cmake_minimum_required(VERSION 3.10)
project(ffmpeg-cmake)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/tools/cmake)
include(util)
include(msvc_util)

option(ENABLE_FF_SHARED "whether or not to build shared ffmpeg" ON)
option(FF_TARGETS "which ff target will be build,default is all,availiable is avcodec avdevice avfilter avformat avutil postproc swresample swscale" "")
option(FF_PACK_ROOT "where to install the ffmpeg library and their headers" "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    option(USING_WSL "using wsl providing bash executing env for such like configure or make" ON)
    option(USING_MSYS "using msys2 for providing bash executing env for such like configure" OFF)
    option(MSYS_PATH "msys installation root path, needed if USING_MSYS==true" "")

    if(NOT USING_WSL AND NOT USING_MSYS)
        message(FATAL_ERROR "must using wsl(${USING_WSL}) or msys(${USING_MSYS})")
    endif()

    # msys env
    if(USING_MSYS)
        find_file(
            MSYS_BASH
            FILENAME bash.exe
            PATHS "${MSYS_PATH}/usr/bin")
        if(NOT MSYS_BASH)
            message(FATAL_ERROR "not found msys bash.exe in specified msys path: \"${MSYS_PATH}\"")
        endif()
        set(ENV{PATH} "${MSYS_PATH};$ENV{PATH}")
    else()
        find_file(
            WSL
            NAME wsl.exe
            PATHS "$ENV{PATH}")
        find_file(
            PWSH
            NAME pwsh.exe powershell.exe
            PATHS "$ENV{PATH}"
        )
        if(NOT WSL)
            message(FATAL_ERROR "wsl is not installed?")
        endif()
        if(NOT PWSH)
            message(FATAL_ERROR "PWSH is missing?")
        endif()
        print(WSL PWSH)
    endif()
endif()

if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
    set(Windows ON)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Linux")
    set(Linux ON)
endif()

if(NOT DEFINED CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

if(ENABLE_FF_SHARED)
    set(IF_ENABLE_FF_SHARED --enable-shared)
endif()

get_filename_component(FFMPEG_ROOT "${CMAKE_CURRENT_LIST_DIR}/ffmpeg" ABSOLUTE)

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

if(NOT IS_DIRECTORY "${FF_PACK_ROOT}/lib")
    file(MAKE_DIRECTORY "${FF_PACK_ROOT}/lib")
endif()

include(configure)
include(avtarget)
include(install)
foreach(FLIB ${FF_TARGETS})
    set_fflib(${FLIB})
    set(FF_MAKE_ALL ${FF_MAKE_ALL} ff_${FLIB})
    set(FF_OUTOUT_TARGETS ${FF_OUTOUT_TARGETS} ffc_${FLIB})
endforeach()


add_custom_target(ff_makeall
    DEPENDS ${FF_MAKE_ALL}
    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/ffmpeg")

    if(NOT "${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_LIST_DIR}")
    set(FF_OUTOUT_TARGETS ${FF_OUTOUT_TARGETS} PARENT_SCOPE)
endif()
