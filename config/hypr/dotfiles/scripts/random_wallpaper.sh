#!/bin/bash

WALLPAPER_DIR="/home/$USER/.config/hypr/wallpapers/"
HISTORY_FILE="/home/$USER/.config/hypr/wallpaper_history"

# Создаем файл истории, если его нет
touch "$HISTORY_FILE"

# Получаем список всех обоев
ALL_WALLPAPERS=($(find "$WALLPAPER_DIR" -type f -printf "%f\n"))

# Если все обои уже использованы, очищаем историю
if [ $(cat "$HISTORY_FILE" | wc -l) -ge ${#ALL_WALLPAPERS[@]} ]; then
    > "$HISTORY_FILE"
fi

# Исключаем использованные обои
AVAILABLE_WALLPAPERS=()
for wp in "${ALL_WALLPAPERS[@]}"; do
    if ! grep -qxF "$wp" "$HISTORY_FILE"; then
        AVAILABLE_WALLPAPERS+=("$wp")
    fi
done

# Выбираем случайные обои из доступных
SELECTED_WALLPAPER=$(printf "%s\n" "${AVAILABLE_WALLPAPERS[@]}" | shuf -n 1)
FULL_PATH="$WALLPAPER_DIR$SELECTED_WALLPAPER"

# Добавляем выбранные обои в историю
echo "$SELECTED_WALLPAPER" >> "$HISTORY_FILE"

# Применяем обои
hyprctl hyprpaper reload ,"$FULL_PATH"