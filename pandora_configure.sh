#!/bin/bash
#
# This script is supposed to ease using the crosscompiler toolchain for the
# pandora with configure based build systems.
#
# Usage example:
# from inside the dir where you normally run a commandline like the following:
#    ./configure --prefix=$HOME/pandora-dev/testcase --disable-strict-compilation
# run this instead to have everything setup for cross compilation:
#    $HOME/pandora-dev/sdk_utils/pandora_configure.sh --prefix=$HOME/pandora-dev/testcase --disable-strict-compilation
# afterwards call 'make' and 'make install', as you are used to. For
# 'make install' you should define a '--prefix=' or you might get problems with
# your normal system.

# first run configure without setting up the cross compiler and make a copy of
# the src/hw_cpu directory

./configure && \
make -C src/hw_cpu && \
rm -rf src/hw_cpu-native && \
cp -r src/hw_cpu src/hw_cpu-native && \
make distclean

PNDSDK=$HOME/pandora-dev/arm-2010.09
TARGET_SYS=arm-none-linux-gnueabi
CROSSTOOL="$PNDSDK/bin/$TARGET_SYS"

#on single long line with all the env vars that make sense to have...
PATH=$PNDSDK/bin:$PNDSDK/usr/bin:$PATH \
LIBTOOL_SYSROOT_PATH=$PNDSDK \
PKG_CONFIG_PATH=$PNDSDK/usr/lib/pkgconfig:libcdio/usr/lib/pkgconfig \
PKG_CONFIG=$PNDSDK/bin/arm-none-linux-gnueabi-pkg-config \
CPATH="$PNDSDK/usr/include:$CPATH" \
CFLAGS="-DPANDORA -D_ARM_ASSEM_ -O3 -pipe -march=armv7-a -mcpu=cortex-a8 -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp -ftree-vectorize -ffast-math -fsingle-precision-constant" \
CPPFLAGS="-DPANDORA -D_ARM_ASSEM_ -O3 -pipe -march=armv7-a -mcpu=cortex-a8 -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp -ftree-vectorize -ffast-math -fsingle-precision-constant" \
CXXFLAGS="-I$PNDSDK/usr/include -I`pwd`/libcdio/usr/include" \
LDFLAGS="-L$PNDSDK/usr/lib -Wl,-rpath,$PNDSDK/usr/lib -L`pwd`/libcdio/usr/lib" \
CXX=$CROSSTOOL-g++ \
CC=$CROSSTOOL-gcc \
AR=$CROSSTOOL-ar \
AS=$CROSSTOOL-as \
RANLIB=$CROSSTOOL-ranlib \
STRIP=$CROSSTOOL-strip \
HOST_CC=gcc \
HOST_CXX=g++ \
./configure --host=$TARGET_SYS --with-gnu-ld \
            --enable-gb=yes \
            --enable-gba=yes \
            --enable-lynx=no \
            --enable-md=no \
            --enable-nes=no \
            --enable-ngp=no \
            --enable-pce=yes \
            --enable-pce-fast=yes \
            --enable-pcfx=no \
            --enable-sms=no \
            --enable-snes=no \
            --enable-wswan=no \
            $*

patch -p1 < patches/src-hw_cpu-makefile.patch
patch -p1 < patches/src-makefile.patch

if [ "$?" -eq "0" ];
then
	echo -e
	echo -e
	echo "Running ./configure was completed. You can now run 'make'. In case you see any"
	echo "problems with your systems include dir being used when running 'make', please"
	echo "betry to export the changed CPATH value. This export will likely be problematic"
	echo "if you want to build non crosscompiled programs in the shell. General advice is"
	echo "to close the current shell after you are done, so that the changed CPATH"
	echo "environment variable is discarded. The export should look like this:"
	echo "export CPATH=\"$PNDSDK/usr/include:\$CPATH\""
	echo "After exporting you can run 'make' just as you are used to."
fi
