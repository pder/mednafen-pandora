#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=480x432

while [ 1 ]
do
    file=`select_rom "lastdir-gb.txt" "Gameboy / Gameboy Color"`
    if [ "$file" == "" ]; then
        exit
    fi
    ./mednafen "$file"
done

