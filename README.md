# ffmpeg-cmake

构建ffmpeg的cmake形式的依赖系统

## How to do it
 cmake and make is all depency-ruled making-program(cmake maybe means make make)
the targets are list below
1. cmake/configure.cmake
2. ffmpeg/config.h config.asm config_components.h
3. libavutil/libavutil.so[.60]
4. \${CMAKE_BINARARY_DIR}/ffmpeg/lib/libavutil.so[.60]

\$1 genrate \$2, \$2 generate \$3 ...
then we have to declare custom_command like 
```cmake
include(cmake/configure.cmake)
add_custom_command(OUTPUT ${FFMPEG_CONFIGURE_OUTPUT}
    COMMAND ${CONFIG_COMMAND}
    DEPENDS "${CMAKE_CURRENT_LIST_DIR}/cmake/configure.cmake"
    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/ffmpeg"
)

#### file cmake/configure.cmake
set(CONFIG_COMMAND ...)
```
commands above is saying: 
    IF the file cmake/configure.cmake changed, call reconfigure
the commands from \$2 to \$3, or any reset part of depency transition is almost the same

## linux
#### pre-requirements

```bash
sudo apt-get update -qq && sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev
 #
sudo apt-get install nasm
# 3rd libs 
sudo apt-get install libx264-dev
sudo apt-get install libx265-dev libnuma-dev
sudo apt-get install libvpx-dev
sudo apt-get install libfdk-aac-dev
sudo apt-get install libopus-dev
sudo apt-get install libdav1d-dev
```

