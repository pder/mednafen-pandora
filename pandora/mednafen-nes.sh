#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=512x448

while [ 1 ]
do
    file=`select_rom "lastdir-nes.txt" "NES"`
    if [ "$file" == "" ]; then
        exit
    fi
    ./mednafen "$file"
done
