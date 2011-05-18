#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=512x480

file=`select_rom "lastdir-vb.txt" "Virtual Boy"`

./mednafen "$file"
