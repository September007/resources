if(DEFINED VS_VCVARSALL_BAT)
    return()
endif()

get_filename_component(VS_TOOLKIT_ROOT "${CMAKE_CXX_COMPILER}/../../../.." ABSOLUTE)
get_filename_component(VS_VC_ROOT "${VS_TOOLKIT_ROOT}/../../.." ABSOLUTE)
get_filename_component(VS_VCVARSALL_BAT "${VS_VC_ROOT}/Auxiliary/Build/vcvarsall.bat" ABSOLUTE)
message("[print] VS_VCVARSALL_BAT:${VS_VCVARSALL_BAT}")
