if(COMMAND set_fflib)
    return()
endif()

include(msvc_util)

function(try_parse_major file RET_VER)
    file(STRINGS ${file} VERSION_FILE_STRS)
    string(REGEX MATCH "#define[ \t]+LIB[A-Z]+_VERSION_MAJOR[ \t]+[0-9]+" DEFINE_STR "${VERSION_FILE_STRS}")
    string(REGEX MATCH "[0-9]+" ${RET_VER} "${DEFINE_STR}")
    set(${RET_VER} ${${RET_VER}} PARENT_SCOPE)
endfunction()

function(ff_parse_major FLIB VER_VAR)
    set(VERION_RET)
    try_parse_major(${FFMPEG_ROOT}/lib${FLIB}/version.h VERSION_VER)
    try_parse_major(${FFMPEG_ROOT}/lib${FLIB}/version_major.h VERSION_MAJOR_VER)

    if(NOT "${VERSION_VER}" STREQUAL "")
        set(VERION_RET ${VERSION_VER})
    elseif(NOT VERSION_MAJOR_VER STREQUAL "")
        set(VERION_RET ${VERSION_MAJOR_VER})
    else()
        message(FATAL_ERROR "can't found version of ${FLIB}")
    endif()
    set(${VER_VAR} ${VERION_RET} PARENT_SCOPE)
endfunction()

function(ff_name_resolve target build_type object_type retName with_build_suffix)
    if(Windows)
        set(FF_PREFIX "")
        set(FF_SUFFIX ".lib")
    elseif(Linux)
        set(FF_PREFIX "lib")

        if("${object_type}" STREQUAL "SHARED")
            set(FF_SUFFIX ".so")
        elseif(Linux)
            set(FF_PREFIX ".a")
        endif()
    endif()

    if(NOT "${build_type}" STREQUAL "Release")
        set(BUILD_SUFFIX "_g") # note win maybe _g too
    else()
        set(BUILD_SUFFIX "")
    endif()

    if(${with_build_suffix})
        set(${retName} "${FF_PREFIX}${target}${BUILD_SUFFIX}${FF_SUFFIX}" PARENT_SCOPE)
    else()
        set(${retName} "${FF_PREFIX}${target}${FF_SUFFIX}" PARENT_SCOPE)
    endif()
endfunction()

function(set_fflib FLIB)

    if(ENABLE_FF_SHARED)
        ff_name_resolve(${FLIB} ${CMAKE_BUILD_TYPE} SHARED libfilename OFF)
    else()
        ff_name_resolve(${FLIB} ${CMAKE_BUILD_TYPE} STATIC libfilename OFF)
    endif()
    message("[print] set_fflib [${FLIB}]: ${libfilename}")
    ff_parse_major(${FLIB} FLIB_VER)

    # 1. make target
    if(Windows)
        if(ENABLE_FF_SHARED)
            set(WIN_BASIC_MAKE_COMMAND make "lib${FLIB}/${FLIB}-${FLIB_VER}.dll" "-j")
        else()
            set(WIN_BASIC_MAKE_COMMAND make "lib${FLIB}/${FLIB}.lib" "-j")
        endif()

        if(USING_MSYS)
            set(MAKE_COMMAND "${MSYS_BASH}" -c "${WIN_BASIC_MAKE_COMMAND}")
        elseif(USING_WSL)
            set(MAKE_COMMAND wsl -- ${WIN_BASIC_MAKE_COMMAND})
        endif()

        set(MAKE_COMMAND echo ${MAKE_COMMAND} | cmd /k "${VS_VCVARSALL_BAT}" x64)
    elseif(Linux)
        set(MAKE_COMMAND make "lib${FLIB}/${libfilename}" "-j")
    endif()

    add_custom_command(
        OUTPUT ${FFMPEG_ROOT}/lib${FLIB}/${FLIB}.lib
        COMMAND ${MAKE_COMMAND}
        DEPENDS ff_configure
        WORKING_DIRECTORY "${FFMPEG_ROOT}"
    )

    # 2.copy libs into destination dir
    if(Windows)
        if(ENABLE_FF_SHARED)
            set(MAYBE_COPY_DLLS
                COMMAND ${CMAKE_COMMAND} -E make_directory ${FF_PACK_ROOT}/bin ${FF_PACK_ROOT}/pdb
                COMMAND ${CMAKE_COMMAND} -E copy "lib${FLIB}/${FLIB}-${FLIB_VER}.dll" "${FF_PACK_ROOT}/bin/"
                COMMAND ${CMAKE_COMMAND} -E copy "lib${FLIB}/${FLIB}-${FLIB_VER}.pdb" "${FF_PACK_ROOT}/pdb/"
            )
        endif()
        set(IMP_LIB ${FF_PACK_ROOT}/lib/${FLIB}.lib)
        add_custom_command(
            OUTPUT ${FF_PACK_ROOT}/lib/${libfilename}
            COMMAND ${CMAKE_COMMAND} -E copy "lib${FLIB}/${FLIB}.lib" "${FF_PACK_ROOT}/lib/"
            ${MAYBE_COPY_DLLS}
            DEPENDS ${FFMPEG_ROOT}/lib${FLIB}/${FLIB}.lib
            WORKING_DIRECTORY "${FFMPEG_ROOT}"
        )
    elseif(Linux)
        add_custom_command(
            OUTPUT ${FF_PACK_ROOT}/lib/${libfilename}
            COMMAND "cp" "-av" "lib${FLIB}/${${FLIB}_NAME} .lib" "${FF_PACK_ROOT}/lib/"
            WORKING_DIRECTORY "${FFMPEG_ROOT}"
        )
    endif()

    # 3. imported target
    
    if(Windows)
        if(ENABLE_FF_SHARED)
            add_library(ffc_${FLIB} SHARED IMPORTED GLOBAL)
            set_target_properties(ffc_${FLIB} PROPERTIES
                IMPORTED_LOCATION "${FF_PACK_ROOT}/bin/${FLIB}-${FLIB_VER}.dll"
                INCLUDE_DIRECTORIES "${FFMPEG_ROOT}"
                IMPORTED_IMPLIB ${FF_PACK_ROOT}/lib/${FLIB}.lib
            )
        else()
        endif()
    elseif(Linux)
        add_library(ffc_${FLIB} SHARED IMPORTED GLOBAL)
        set_target_properties(ffc_${FLIB} PROPERTIES
            IMPORTED_LOCATION "${FF_PACK_ROOT}/bin/lib${FLIB}-${FLIB_VER}.so"
            INCLUDE_DIRECTORIES "${FFMPEG_ROOT}"
            IMPORTED_LINK_DEPENDENT_LIBRARIES ${FF_PACK_ROOT}/lib/${${FLIB}_NAME}
        )
    endif()
    target_include_directories(ffc_${FLIB} SYSTEM BEFORE INTERFACE "${FFMPEG_ROOT}")
    add_library(ffc::${FLIB} ALIAS ffc_${FLIB})
    add_dependencies(ffc_${FLIB} ${FF_PACK_ROOT}/lib/${libfilename} ff_configure)
    
    add_custom_target(ff_${FLIB}
        DEPENDS ${FF_PACK_ROOT}/lib/${libfilename} 
        )
endfunction()

print(FF_PACK_ROOT)