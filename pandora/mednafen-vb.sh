#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=768x448

while [ 1 ]
do
    file=`select_rom "lastdir-vb.txt" "Virtual Boy"`
    if [ "$file" == "" ]; then
        exit
    fi
    ./mednafen "$file"
done
