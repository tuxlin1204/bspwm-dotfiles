#!/bin/bash

setxkbmap -layout us,ru -option "grp:win_space_toggle"
xdotool key ISO_Next_Group

sleep 0.05

LAYOUT=$(xset -q | awk '/LED/ {print $10}')

if [ "$LAYOUT" = "00000000" ]; then
    notify-send "Lang: US" -t 700
else
    notify-send "Lang: RU" -t 700
fi
