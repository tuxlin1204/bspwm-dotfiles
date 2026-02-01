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

# Run on the desired monitor
if [[ $(xrandr -q | grep 'HDMI-0 connected' ) ]]; then
	polybar top_external -r >>/tmp/polybar1.log 2>&1 & disown
	polybar top -r >>/tmp/polybar1.log 2>&1 & disown
	echo "Polybar launched for two monitors"
else
	polybar top -r >>/tmp/polybar1.log 2>&1 & disown
	echo "Polybar launched for one monitor..."
fi
