#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Auto-detect backlight
export POLYBAR_BACKLIGHT=$(
  for d in /sys/class/backlight/*; do
    [ -f "$d/max_brightness" ] || continue
    echo "$(cat "$d/max_brightness") $(basename "$d")"
  done 2>/dev/null | sort -nr | head -n1 | awk '{print $2}'
)

# (опционально) если backlight не найден — лог
if [[ -z "$POLYBAR_BACKLIGHT" ]]; then
  echo "No backlight detected" >> /tmp/polybar1.log
fi

# Auto-detect battery
export POLYBAR_BATTERY=$(ls /sys/class/power_supply 2>/dev/null | grep -E '^BAT' | head -n 1)

# (опционально) если батарея не найдена — лог
if [[ -z "$POLYBAR_BATTERY" ]]; then
  echo "No battery detected" >> /tmp/polybar1.log
fi

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log


# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log


# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log

# получаем список подключённых мониторов
MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)
COUNT=$(echo "$MONITORS" | wc -l)

if [[ "$COUNT" -eq 1 ]]; then
    # один монитор → один polybar
    MONITOR=$MONITORS polybar top -r &
else
    # несколько мониторов → по polybar на каждый
    for m in $MONITORS; do
        if [[ "$m" == "eDP-1" ]]; then
            MONITOR=$m polybar top -r &
        else
           MONITOR=$m polybar top_external -r &
        fi
    done
fi
