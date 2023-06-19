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

message("CONFIG_COMMAND:${CONFIG_COMMAND}")