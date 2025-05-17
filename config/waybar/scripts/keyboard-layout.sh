#!/bin/bash

# Getting data
layout=$(hyprctl -j activewindow | jq -r '.keyboardLayout')
    if [[ -z "$layout" || "$layout" == "null" ]]; then
        layout=$(hyprctl -j devices | jq -r '.keyboards[] | select(.name | contains("translated")) | .active_keymap' | head -n 1)
    fi

# Forming a block
case "$layout" in
    "Russian"|"ru") echo "{\"text\":\"RU\"}" ;;
    *) echo "{\"text\":\"US\"}" ;;
esac
