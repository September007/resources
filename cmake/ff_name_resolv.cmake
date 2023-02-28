
# ff_name_resolve(${FLIB} ${CMAKE_BUILD_TYPE} SHARED ${FLIB}_NAME OFF)
macro(ff_name_resolve target build_type object_type retName with_build_suffix)
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

    if(NOT "${build_type}" STREQUAL "Release")
        set(BUILD_SUFFIX "_g") # note win maybe _g too
    else()
        set(BUILD_SUFFIX "")
    endif()

    if(${with_build_suffix})
        set(${retName} "${FF_PREFIX}${target}${BUILD_SUFFIX}${FF_SUFFIX}")
    else()
        set(${retName} "${FF_PREFIX}${target}${FF_SUFFIX}")
    endif()
endmacro()

macro(exists_FF_TARGES destDir retVal)
    set(${retVal} ON)

    foreach(FF_TARGET ${FF_TARGETS})
        name_resolve(${FF_TARGET} ${CMAKE_BUILD_TYPE} ${FF_LIB_FORM} ${FF_TARGET}_name)

        if(NOT EXISTS "${destDir}/${${FF_TARGET}_name}")
            set(${retVal} OFF)
        endif()
    endforeach()
endmacro()
