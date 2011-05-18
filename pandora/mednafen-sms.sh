#!/bin/sh

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=512x480

file=`select_rom "lastdir-sms.txt" "Sega Master System / Game Gear"`

./mednafen "$file"
