#!/bin/sh

export LD_LIBRARY_PATH=`pwd`/lib
export SDL_VIDEODRIVER=omapdss
export SDL_OMAP_VSYNC=1
export MEDNAFEN_HOME=`pwd`/.mednafen

if [ ! -d .mednafen ] ; then
    cp -r mednafen-default .mednafen
fi

function select_rom()
{
    here=`pwd`
    lastdir=`cat "$here/$1"`
    cd "$lastdir" && file="`zenity --file-selection --title="Select a $2 rom"`"
    lastdir=`dirname "$file"`
    echo $lastdir > "$here/$1"
    cd "$here"
    echo $file
}
