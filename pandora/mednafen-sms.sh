#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=512x480

while [ 1 ]
do
    file=`select_rom "lastdir-sms.txt" "Sega Master System / Game Gear"`
    if [ "$file" == "" ]; then
        exit
    fi
    ./mednafen "$file"
done
