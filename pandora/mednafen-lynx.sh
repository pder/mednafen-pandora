#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=640x408

file=`select_rom "lastdir-lynx.txt" "Atari Lynx"`

./mednafen "$file"
