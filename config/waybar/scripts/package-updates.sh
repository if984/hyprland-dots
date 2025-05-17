#!/bin/bash

SHOW_AUR=true
LAST_UPDATE_CHECK=0

# Getting data
check_updates() {
  # PACMAN
  if ! command -v checkupdates &>/dev/null; then
    echo "Error: checkupdates not installed!" >&2
    return 1
  fi
  pacman_updates=$(checkupdates 2>/dev/null | wc -l)
  
  # AUR
  if [[ "$SHOW_AUR" == true ]] && command -v yay &>/dev/null; then
    aur_updates=$(yay -Qua 2>/dev/null | wc -l)
  else
    aur_updates=0
  fi
  
  echo $((pacman_updates + aur_updates))
}

# We update the cache every 1 hour
if (( $(date +%s) - LAST_UPDATE_CHECK >= 3600 )); then
  if CACHED_UPDATE_COUNT=$(check_updates); then
    LAST_UPDATE_CHECK=$(date +%s)
  else
    CACHED_UPDATE_COUNT=-1
  fi
fi

# Forming a block
if (( CACHED_UPDATE_COUNT == -1 )); then
  echo "{\"text\": \"ERROR\", \"class\": \"critical\"}"
elif (( CACHED_UPDATE_COUNT > 0 )); then
  echo "{\"text\": \"$CACHED_UPDATE_COUNT\", \"class\": \"warning\"}"
else
  echo "{\"text\": \"OK\"}"
fi