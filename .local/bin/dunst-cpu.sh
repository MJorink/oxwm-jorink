#!/bin/bash
# setGovernor

msgTag="cpugovernor"

governor="$1"

# Check if argument is provided
if [[ -z "$governor" ]]; then
    dunstify -t 2000 -u critical -h string:x-dunst-stack-tag:$msgTag \
    "CPU Governor" "No governor specified!"
    exit 1
fi

# Try to set governor
if sudo cpupower frequency-set --governor "$governor" > /dev/null 2>&1; then
    dunstify -t 1500 -u low -h string:x-dunst-stack-tag:$msgTag \
    "CPU Governor set to: $governor"
else
    dunstify -t 2000 -u critical -h string:x-dunst-stack-tag:$msgTag \
    "Failed to set governor: $governor"
fi
