#!/bin/bash

detect_monitors() {
    xrandr --query | grep -w "connected" | awk '{print $1}'
}

classify_monitor() {
    local monitor=$1
    if [[ "$monitor" == eDP* ]] || [[ "$monitor" == LVDS* ]]; then
        echo "internal"
    else
        echo "external"
    fi
}

get_mode() {
    local monitor=$1
    local mode

    mode=$(xrandr --query | awk -v mon="$monitor" '
        $1 == mon && $2 == "connected" {
            getline
            if ($1 ~ /^[0-9]+x[0-9]+$/) {
                print $1
                exit
            }
        }
    ')

    [[ -z "$mode" ]] && mode="1920x1080"
    echo "$mode"
}

main() {
    local monitors=($(detect_monitors))

    if [[ ${#monitors[@]} -eq 0 ]]; then
        echo "No connected monitors detected."
        exit 1
    fi

    # DVI-I-0 всегда первым.
    # Поэтому он будет настроен первым, в позиции 0x0, и станет PRIMARY.
    if printf '%s\n' "${monitors[@]}" | grep -qx "DVI-I-0"; then
        local ordered=("DVI-I-0")
        for monitor in "${monitors[@]}"; do
            [[ "$monitor" != "DVI-I-0" ]] && ordered+=("$monitor")
        done
        monitors=("${ordered[@]}")
    else
        echo "WARNING: DVI-I-0 is not connected."
        echo "The first detected monitor will be used as PRIMARY."
    fi

    echo "Detected monitors: ${monitors[*]}"

    local internal_monitor=""
    local external_monitors=()

    for monitor in "${monitors[@]}"; do
        local type
        type=$(classify_monitor "$monitor")

        if [[ "$type" == "internal" ]]; then
            internal_monitor="$monitor"
        else
            external_monitors+=("$monitor")
        fi
    done

    echo "Internal monitor: ${internal_monitor:-none}"
    echo "External monitors: ${external_monitors[*]:-none}"

    # Сначала отключаем все мониторы.
    for monitor in "${monitors[@]}"; do
        xrandr --output "$monitor" --off
    done
    sleep 1

    local count=${#monitors[@]}

    if (( count > 1 )); then
        echo "Multiple monitors detected."

        local prev_monitor=""

        # DVI-I-0 находится первым в массиве.
        for i in "${!monitors[@]}"; do
            local monitor="${monitors[$i]}"
            local mode
            mode=$(get_mode "$monitor")

            if (( i == 0 )); then
                echo "Setting $monitor as PRIMARY at 0x0 ($mode)"

                xrandr                     --output "$monitor"                     --primary                     --mode "$mode"                     --pos 0x0                     --rotate normal

                prev_monitor="$monitor"
            else
                echo "Setting $monitor to the right of $prev_monitor ($mode)"

                xrandr                     --output "$monitor"                     --mode "$mode"                     --right-of "$prev_monitor"                     --rotate normal

                prev_monitor="$monitor"
            fi

            sleep 1
        done

        # Явно повторно назначаем DVI-I-0 основным.
        if printf '%s\n' "${monitors[@]}" | grep -qx "DVI-I-0"; then
            xrandr --output DVI-I-0 --primary
        fi

        # Настройка bspwm: по 4 рабочих стола на каждый монитор.
        for monitor in "${monitors[@]}"; do
            bspc monitor "$monitor" -r all 2>/dev/null || true
        done

        local desktop_num=1

        for monitor in "${monitors[@]}"; do
            echo "Assigning desktops $desktop_num-$((desktop_num + 3)) to $monitor"

            bspc monitor "$monitor" -d                 "$desktop_num"                 "$((desktop_num + 1))"                 "$((desktop_num + 2))"                 "$((desktop_num + 3))"

            desktop_num=$((desktop_num + 4))
        done

    else
        local monitor="${monitors[0]}"
        local mode
        mode=$(get_mode "$monitor")

        echo "Single monitor detected: $monitor"

        xrandr             --output "$monitor"             --primary             --mode "$mode"             --pos 0x0             --rotate normal

        sleep 1

        bspc monitor "$monitor" -r all 2>/dev/null || true
        bspc monitor "$monitor" -d 1 2 3 4 5 6 7 8
    fi

    # Настройки курсора.
    bspc config focus_follows_pointer true
    bspc config pointer_follows_focus false
    bspc config pointer_follows_monitor true

    # Обои.
    if command -v feh &> /dev/null; then
        feh --bg-fill --no-fehbg ~/.config/wallpaper.jpg 2>/dev/null || true
    fi

    # Polybar.
    if command -v polybar &> /dev/null; then
        pkill -f "polybar top" 2>/dev/null || true
        sleep 1

        for monitor in "${monitors[@]}"; do
            echo "Starting polybar on $monitor"
            MONITOR="$monitor" polybar top &
            sleep 0.5
        done
    fi

    echo "Monitor setup completed."
    echo "Primary monitor should be: DVI-I-0"
}

main

