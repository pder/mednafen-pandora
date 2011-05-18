#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=480x456

file=`select_rom "lastdir-ngp.txt" "Neo Geo Pocket"`

./mednafen "$file"
