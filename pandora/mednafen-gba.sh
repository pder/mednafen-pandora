#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=720x480

while [ 1 ]
do
    file=`select_rom "lastdir-gba.txt" "GBA"`
    if [ "$file" == "" ]; then
        exit
    fi
    ./mednafen "$file"
done
