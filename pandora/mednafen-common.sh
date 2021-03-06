#!/bin/bash

export LD_LIBRARY_PATH=`pwd`/lib
export SDL_VIDEODRIVER=omapdss
export SDL_OMAP_VSYNC=1
export MEDNAFEN_HOME=`pwd`/.mednafen

if [ ! -d .mednafen ] ; then
    cp -r mednafen-default .mednafen
fi

if [ ! -e .mednafen/mednafen-09x.cfg ] ; then
    cp mednafen-default/mednafen-09x.cfg .mednafen/
fi

function select_rom()
{
    here=`pwd`
    lastdir=`cat "$here/$1"`
    cd "$lastdir" 
    file="`zenity --file-selection --title="Select a $2 rom"`"
    lastdir=`dirname "$file"`
    if [ "$file" != "" ] ; then
        echo $lastdir > "$here/$1"
    fi
    cd "$here"
    echo $file
}
