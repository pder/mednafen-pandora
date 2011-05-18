#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=480x432

file=`select_rom "lastdir-lynx.txt" "Atari Lynx"`

./mednafen "$file"
