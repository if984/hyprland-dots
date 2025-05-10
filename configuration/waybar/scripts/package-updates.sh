#!/bin/bash

# Проверка AUR
SHOW_AUR=true

# Кэш обновлений
LAST_UPDATE_CHECK=0

# Функции получения данных
check_updates() {
  # PACMAN обновления
  if ! command -v checkupdates &>/dev/null; then
    echo "Error: checkupdates not installed!" >&2
    return 1
  fi
  pacman_updates=$(checkupdates 2>/dev/null | wc -l)
  
  # AUR обновления
  if [[ "$SHOW_AUR" == true ]] && command -v yay &>/dev/null; then
    aur_updates=$(yay -Qua 2>/dev/null | wc -l)
  else
    aur_updates=0
  fi
  
  echo $((pacman_updates + aur_updates))
}

# Обновляем кэш каждый 1 час
if (( $(date +%s) - LAST_UPDATE_CHECK >= 3600 )); then
  if CACHED_UPDATE_COUNT=$(check_updates); then
    LAST_UPDATE_CHECK=$(date +%s)
  else
    CACHED_UPDATE_COUNT=-1
  fi
fi

# Формируем блок
if (( CACHED_UPDATE_COUNT == -1 )); then
  echo "{\"text\": \"ERROR\", \"class\": \"critical\"}"
elif (( CACHED_UPDATE_COUNT > 0 )); then
  echo "{\"text\": \"$CACHED_UPDATE_COUNT\", \"class\": \"warning\"}"
else
  echo "{\"text\": \"OK\"}"
fi