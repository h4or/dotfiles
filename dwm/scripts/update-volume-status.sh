#!/bin/bash

output_file="/home/h4or/.config/h4orwm/dwm/scripts/volume_percentage.txt"

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '(\d+)%' | head -n 1)

echo "${volume}" > "$output_file"
