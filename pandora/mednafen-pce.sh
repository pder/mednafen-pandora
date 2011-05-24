#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=684x464

while [ 1 ]
do
    file=`select_rom "lastdir-pce.txt" "PC Engine / Turbografx 16"`
    if [ "$file" == "" ]; then
        exit
    fi
    ./mednafen -force_module pce_fast "$file"
done
