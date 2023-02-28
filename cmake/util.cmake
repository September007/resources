
macro(print)
    # set(sarg HINT) # hint
    # set(marg VARS) # this will be unfounded
    # cmake_parse_arguments(PRINT_ARGS "" "${sarg}" "${marg}" ${ARGN})

    # if(${PRINT_ARGS_HINT})
    #     set(MSG "${PRINT_ARGS_HINT}:")
    # else()
    #     set(MSG)
    # endif()

    # foreach(var ${PRINT_ARGS_UNPARSED_ARGUMENTS}) # unparsed
    #     string(APPEND MSG ${MSG} "|${var}:${${var}}|")
    # endforeach()

    foreach(var ${ARGN}) # unparsed
        string(APPEND MSG ${MSG} "|${var}:${${var}}|")
    endforeach()
    message("${MSG}")
endmacro()
