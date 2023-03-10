set(CONFIG_COMMAND "./configure" 
--extra-libs=\"-lpthread -lm\" 
${IF_ENABLE_FF_SHARED}
--ld=\"g++\" 
--prefix=\"${CMAKE_BINARY_DIR}/ffmpeg_pack\"
# debug info
# https://stackoverflow.com/questions/9211163/debugging-ffmpeg
--enable-debug=3 # https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html#Debugging-Options
--disable-optimizations
--extra-cflags=-fno-omit-frame-pointer
--extra-cflags=-fno-inline
# --extra-cflags=-Og
# --extra-ldsoflags="-Wl,-rpath=\\\$ ORIGIN" # \\$$ORIGIN  
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
#--enable-libfdk-aac 
#--enable-nonfree 
)
message("CONFIG_COMMAND:${CONFIG_COMMAND}")