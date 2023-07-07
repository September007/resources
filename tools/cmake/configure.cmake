
set(FFMPEG_CONFIGURE_OUTPUTS
    "${FFMPEG_ROOT}/config.h"
)

if(Windows)
    include(msvc_util)

    if(USING_MSYS)
        set(CONFIG_COMMAND "./configure"
            --toolchain=msvc
            ${IF_ENABLE_FF_SHARED}
            --extra-cflags=/utf-8
            --prefix=${FF_PACK_ROOT}/install
        )
    elseif(USING_WSL)
        set(CONFIGURE_WSL "./configure.wsl")
        set(CONFIG_COMMAND echo wsl.exe -u lull -- "./configure.wsl"
            --toolchain=msvc
            ${IF_ENABLE_FF_SHARED}
            --extra-cflags=/utf-8
            | cmd /k "${VS_VCVARSALL_BAT}" x64)

        get_filename_component(CONFIGURE_WSL_ABS_PATH "${FFMPEG_ROOT}/${CONFIGURE_WSL}" ABSOLUTE)
        get_filename_component(SCRIPT_GEN_CONFIGURE_WSL "${CMAKE_CURRENT_LIST_DIR}/../scripts/wsl_init_configure.ps1" ABSOLUTE)
        add_custom_command(OUTPUT ${CONFIGURE_WSL_ABS_PATH}

            # COMMAND where.exe pwsh
            COMMAND where.exe powershell
            COMMAND echo "PWSH:${PWSH}"
            COMMAND "${PWSH}" -ExecutionPolicy Unrestricted ${SCRIPT_GEN_CONFIGURE_WSL} -in ${FFMPEG_ROOT}/configure -out ${CONFIGURE_WSL_ABS_PATH}
            DEPENDS_EXPLICIT_ONLY ${SCRIPT_GEN_CONFIGURE_WSL})

        add_custom_target(ff_gen_wsl_configure DEPENDS ${CONFIGURE_WSL_ABS_PATH} ${FFMPEG_ROOT}/configure)
        set(MAYBE_FF_GEN_WSL_CONFIG ff_gen_wsl_configure)
        print(CONFIGURE_WSL_ABS_PATH SCRIPT_GEN_CONFIGURE_WSL)
    endif()
elseif(Linux)
    # # the character escaping
    # cmake raw             \\\\\\\$\$ORIGIN
    # ninja                 \\\$$ORIGIN
    # configure option      \\\$ORIGIN
    # make command          \$ORIGIN
    if(CMAKE_BUILD_TYPE STREQUAL Release)
    else()
        set(CONFIG_COMMAND "./configure"
            --extra-libs=\"-lpthread -lm\"
            ${IF_ENABLE_FF_SHARED}
            --ld="g++"
            --prefix="${CMAKE_BINARY_DIR}/ffmpeg_pack"
            --enable-debug=3 # https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html#Debugging-Options
            --disable-optimizations
            --extra-cflags=-fno-omit-frame-pointer
            --extra-cflags=-fno-inline
            --extra-ldsoflags="-Wl,-rpath=\\\\\\\$\$ORIGIN"
            --enable-pic
            --enable-gpl
            --enable-gnutls
            --enable-libass
            --enable-libfreetype
            --enable-libmp3lame
            --enable-libopus
            --enable-libvorbis
            --enable-libvpx
            --enable-libx264
            --enable-libx265
            --enable-libdav1d
        )
    endif()
endif()

print(CONFIG_COMMAND)


if(Windows)
    # change codepage to utf-8 maybe not working, so config.h maybe GBK
    # the ../tools/scriptes/file_coding_convert.bash is for iconv converte file coding
    add_custom_command(OUTPUT ${FFMPEG_CONFIGURE_OUTPUTS}
        COMMAND chcp 65001
        COMMAND ${CONFIG_COMMAND}
        COMMAND wsl -- bash -c "../tools/scripts/file_coding_convert.bash config.h"
        DEPENDS
        "${CMAKE_CURRENT_LIST_DIR}/configure.cmake"
        ${FFMPEG_ROOT}/configure
        ${MAYBE_FF_GEN_WSL_CONFIG}
        WORKING_DIRECTORY "${FFMPEG_ROOT}"
    )
elseif(Linux)
    add_custom_command(OUTPUT ${FFMPEG_CONFIGURE_OUTPUTS}
        COMMAND ${CONFIG_COMMAND}
        DEPENDS
        "${CMAKE_CURRENT_LIST_DIR}/configure.cmake"
        ${FFMPEG_ROOT}/configure
        WORKING_DIRECTORY "${FFMPEG_ROOT}"
    )
endif()

add_custom_target(ff_configure
    DEPENDS ${FFMPEG_CONFIGURE_OUTPUTS}
    VERBATIM
)
