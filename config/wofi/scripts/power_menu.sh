#!/bin/bash
case $(echo -e "Shutdown\nReboot\nSuspend\nLogout" | wofi --dmenu -p "Power Menu:") in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Suspend) systemctl suspend ;;
    Logout) hyprctl dispatch exit ;;
esac