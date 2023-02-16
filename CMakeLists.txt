cmake_minimum_required(VERSION 3.10)

if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
    set(Windows ON)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Linux")
    set(Linux ON)
endif()

if(NOT DEFINED FF_LIB_FORM)
    set(FF_LIB_FORM SHARED) # SHARED OR STATIC
endif()

if(NOT DEFINED FF_TARGET_LIBS_ROOT)
    set(FF_TARGET_LIBS_ROOT ${CMAKE_CURRENT_LIST_DIR}/install/lib ) # root dir to libs
endif()

if(NOT DEFINED FF_TARGET_INCS_ROOT)
    set(FF_TARGET_INCS_ROOT ${CMAKE_CURRENT_LIST_DIR}/install/include ) # root dir to headers
endif()

if(NOT DEFINED FF_TARGETS)
    set(FF_TARGETS          # targets
        avcodec
        avdevice
        avfilter
        avformat
        avutil
        postproc
        swresample
        swscale)
endif()

macro(print)
    set(sarg HINT) # hint
    set(marg VARS) # this will be unfounded
    cmake_parse_arguments(PRINT_ARGS "" "${sarg}" "${marg}" ${ARGN})

    if(${PRINT_ARGS_HINT})
        set(MSG "${PRINT_ARGS_HINT}:")
    else()
        set(MSG)
    endif()
    foreach(var ${PRINT_ARGS_UNPARSED_ARGUMENTS}) # unparsed
        string(APPEND MSG ${MSG} "|${var}:${${var}}|")
    endforeach()
    message("${MSG}")
endmacro()

print(FF_TARGETS)

# target:avcodec build_type:${CMAKE_BUILD_TYPE} object_type SHARED/RELEASE retName:var to receive result
macro(name_resolve target build_type object_type retName)
    if(Windows)
        set(FF_PREFIX)

        if("${object_type}" STREQUAL "SHARED")
            set(FF_SUFFIX ".dll")
        elseif(Linux)
            set(FF_PREFIX ".lib")
        endif()
    elseif(Linux)
        set(FF_PREFIX "lib")

        if("${object_type}" STREQUAL "SHARED")
            set(FF_SUFFIX ".so")
        elseif(Linux)
            set(FF_PREFIX ".a")
        endif()
    endif()

    if(Windows AND NOT "${build_type}" STREQUAL "Release")
        set(EXTRA_SUFFIX "_d")
    else()
        set(EXTRA_SUFFIX)
    endif()

    set(${retName} "${FF_PREFIX}${target}${EXTRA_SUFFIX}${FF_SUFFIX}")
endmacro()

# name_resolve(avcodec ${CMAKE_BUILD_TYPE} SHARED avcodec_dll_name)
# print(avcodec_dll_name)

macro(exists_FF_TARGES destDir retVal)
    set(${retVal} ON)
    foreach(FF_TARGET ${FF_TARGETS})
        name_resolve(${FF_TARGET} ${CMAKE_BUILD_TYPE} ${FF_LIB_FORM} ${FF_TARGET}_name)
        if(NOT EXISTS "${destDir}/${${FF_TARGET}_name}")
            set(${retVal} OFF)
        endif()
    endforeach()
endmacro()

macro(ffmpeg_build source_dir build_type )

endmacro()

macro(ffmpeg_clean source_dir)
endmacro()

macro(ffmpeg_install source_dir lib_dir header_dir)
endmacro()


exists_FF_TARGES(${FF_TARGET_LIBS_ROOT} IS_FF_TARGETS_EXIST)
if(NOT IS_FF_TARGETS_EXIST)

endif()
add_library( avcodec SHARED IMPORTED )
 
#指定所添加依赖库的导入路径
set_target_properties( avcodec PROPERTIES IMPORTED_LOCATION ${ffmpeg_libs_DIR}/libavcodec.so )
 
add_library( avfilter SHARED IMPORTED )
set_target_properties( avfilter PROPERTIES IMPORTED_LOCATION ${ffmpeg_libs_DIR}/libavfilter.so )
 
add_library( swresample SHARED IMPORTED )
set_target_properties( swresample PROPERTIES IMPORTED_LOCATION ${ffmpeg_libs_DIR}/libswresample.so )
 
add_library( swscale SHARED IMPORTED )
set_target_properties( swscale PROPERTIES IMPORTED_LOCATION ${ffmpeg_libs_DIR}/libswscale.so )
 
add_library( avformat SHARED IMPORTED )
set_target_properties( avformat PROPERTIES IMPORTED_LOCATION ${ffmpeg_libs_DIR}/libavformat.so )
 
add_library( avutil SHARED IMPORTED )
