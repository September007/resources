
include(msvc_util)
if(Windows)
    if(USING_MSYS)
    elseif(USING_WSL)
        add_custom_target(ff_install
            COMMAND echo wsl -- make install | cmd /k "${VS_VCVARSALL_BAT}" x64
            DEPENDS ff_makeall
            WORKING_DIRECTORY ${FFMPEG_ROOT}
        )
    endif()
endif()