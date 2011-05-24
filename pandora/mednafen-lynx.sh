#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=640x408

while [ 1 ]
do
    file=`select_rom "lastdir-lynx.txt" "Atari Lynx"`
    if [ "$file" == "" ]; then
        exit
    fi
    ./mednafen "$file"
done
