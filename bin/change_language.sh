#!/bin/bash

CURRENT_LAYOUT=$(setxkbmap -query | awk '/layout/ {print $2}')

if [ "$CURRENT_LAYOUT" = "us" ]; then
    setxkbmap -layout ru
    notify-send "Lang: RU" -t 700
else
    setxkbmap -layout us
    notify-send "Lang: US" -t 700
fi
