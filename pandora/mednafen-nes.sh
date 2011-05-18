#!/bin/sh

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=512x448

file=`select_rom "lastdir-nes.txt" "NES"`

./mednafen "$file"
