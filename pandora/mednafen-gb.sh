#!/bin/sh

export LD_LIBRARY_PATH=`pwd`/lib
export SDL_VIDEODRIVER=omapdss
export SDL_OMAP_LAYER_SIZE=480x432
export SDL_OMAP_VSYNC=1
export MEDNAFEN_HOME=`pwd`/.mednafen

if [ ! -d .mednafen ] ; then
    cp -r mednafen-default .mednafen
fi

./mednafen "$1"
