
function(print)
    foreach(var ${ARGN}) # unparsed
        message("[print] ${var}:${${var}}")
    endforeach()
endfunction()
