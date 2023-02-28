    ./configura                 \
    --extra-libs="-lpthread -lm" \
    ${IF_ENABLE_FF_SHARED}      \
    --ld="g++"              \
    --enable-debug=3 # https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html#Debugging-Options\\    --enable-gpl 
    --enable-gnutls         \ 
    --enable-libass         \ 
    --enable-libfreetype    \ 
    --enable-libmp3lame     \ 
    --enable-libopus        \ 
    --enable-libvorbis      \ 
    --enable-libvpx         \ 
    --enable-libx264        \ 
    --enable-libx265        \ 
    --enable-libdav1d       \ 