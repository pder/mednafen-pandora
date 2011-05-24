#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=480x456

while [ 1 ]
do
    file=`select_rom "lastdir-ngp.txt" "Neo Geo Pocket"`
    if [ "$file" == "" ]; then
        exit
    fi
    ./mednafen "$file"
done
