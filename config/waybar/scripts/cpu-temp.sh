#!/bin/bash

# Getting data
temp=$(cat /sys/class/thermal/thermal_zone7/temp | awk '{print int($1 / 1000)}')

# Forming a block
if [ "$temp" -ge 85 ]; then
    echo "{\"text\": \"$temp\", \"class\": \"critical\"}"
elif [ "$temp" -ge 65 ]; then
    echo "{\"text\": \"$temp\", \"class\": \"warning\"}"
else
    echo "{\"text\": \"$temp\"}"
fi
