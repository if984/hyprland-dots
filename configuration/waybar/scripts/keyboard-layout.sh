#!/bin/bash
layout=$(hyprctl -j activewindow | jq -r '.keyboardLayout')
    # Если вариант 1 не сработал, пробуем вариант 2
    if [[ -z "$layout" || "$layout" == "null" ]]; then
        # Вариант 2: Через список устройств ввода
        layout=$(hyprctl -j devices | jq -r '.keyboards[] | select(.name | contains("translated")) | .active_keymap' | head -n 1)
    fi

case "$layout" in
    "Russian"|"ru") echo "{\"text\":\"RU\"}" ;;
    *) echo "{\"text\":\"US\"}" ;;
esac
