#!/bin/bash

swww query
if [ $? -eq 1 ]; then
    swww-daemon --format xrgb
    swww img ~/.config/swww/wm-bg1.png \
        --transition-type "wipe" \
        --transition-duration 3
fi
