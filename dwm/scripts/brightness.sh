#!/bin/bash

# Function to adjust brightness for all connected monitors
adjust_brightness() {
    direction=$1  # Argument: 'increase' or 'decrease'
    
    # Get the list of connected monitors
    connected_monitors=$(xrandr | grep " connected" | awk '{print $1}')
    
    if [[ -z $connected_monitors ]]; then
        echo "No monitors are connected."
        exit 1
    fi

    for monitor in $connected_monitors; do
        current_brightness=$(xrandr --verbose --current | grep -i 'Brightness:' | awk '{print $2}' | head -n 1)
        
        if [[ -n $current_brightness ]]; then
            if [[ $direction == "increase" ]]; then
                new_brightness=$(echo "$current_brightness + 0.1" | bc)
            elif [[ $direction == "decrease" ]]; then
                new_brightness=$(echo "$current_brightness - 0.1" | bc)
            else
                echo "Invalid argument. Use 'increase' or 'decrease'."
                exit 1
            fi
            
            # Apply new brightness to the current monitor
            xrandr --output $monitor --brightness $new_brightness
        else
            echo "Failed to get current brightness for $monitor."
        fi
    done
}

# Check if argument is provided
if [[ -z $1 ]]; then
    echo "Please provide 'increase' or 'decrease' as an argument."
    exit 1
fi

# Call the function with the passed argument
adjust_brightness $1
