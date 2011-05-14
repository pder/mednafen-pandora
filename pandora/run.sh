#!/bin/bash
if [ ! -f "./profile.txt" ]; then
    cp -R picklelauncher-default/* ./
fi
./picklelauncher
