#!/bin/bash
# changeBrightness

msgTag="mybrightness"

# Change brightness (e.g. +5%, 5%-, etc.)
brightnessctl set "$@" > /dev/null

# Get current brightness percentage
brightness="$(brightnessctl -m | cut -d',' -f4 | tr -d '%')"

if [[ "$brightness" == "0" ]]; then
    dunstify -t 1000 -a "changeBrightness" -u low \
        -i display-brightness-off \
        -h string:x-dunst-stack-tag:$msgTag \
        "Brightness: 0%"
else
    dunstify -t 1000 -a "changeBrightness" -u low \
        -i display-brightness-high \
        -h string:x-dunst-stack-tag:$msgTag \
        -h int:value:"$brightness" \
        "Brightness: ${brightness}%"
fi
