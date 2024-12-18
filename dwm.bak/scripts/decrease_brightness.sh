#!/bin/bash

# Function to decrease brightness by 0.1
decrease_brightness() {
    current_brightness=$(xrandr --verbose --current | grep -i 'Brightness:' | awk '{print $2}' | head -n 1)
    if [[ -n $current_brightness ]]; then
        new_brightness=$(echo "$current_brightness - 0.1" | bc)
        xrandr --output HDMI-A-1 --brightness $new_brightness
        xrandr --output DVI-D-1 --brightness $new_brightness
    else
        echo "Failed to get current brightness."
    fi
}

# Call the function
decrease_brightness

