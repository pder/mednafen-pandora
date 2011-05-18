#!/bin/bash

source ./mednafen-common.sh

export SDL_OMAP_LAYER_SIZE=480x432

file=`select_rom "lastdir-gb.txt" "Gameboy / Gameboy Color"`

./mednafen "$file"
