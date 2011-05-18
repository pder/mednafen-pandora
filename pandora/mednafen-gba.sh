#!/bin/sh

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=720x480

file=`select_rom "lastdir-gba.txt" "GBA"`

./mednafen "$file"
