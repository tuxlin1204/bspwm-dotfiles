#!/bin/bash

# Функция для определения подключенных мониторов
detect_monitors() {
    xrandr --query | grep -w "connected" | awk '{print $1}'
}

# Функция для классификации мониторов
classify_monitor() {
    local monitor=$1
    if [[ $monitor == eDP* ]] || [[ $monitor == LVDS* ]]; then
        echo "internal"
    else
        echo "external"
    fi
}

main() {
    local monitors=($(detect_monitors))
    echo "Detected monitors: ${monitors[*]}"

    local internal_monitor=""
    local external_monitors=()

    for monitor in "${monitors[@]}"; do
        type=$(classify_monitor "$monitor")
        if [[ $type == "internal" ]]; then
            internal_monitor="$monitor"
        else
            external_monitors+=("$monitor")
        fi
    done

    # Если внутренний монитор не найден, берем первый
    if [[ -z "$internal_monitor" ]] && [[ ${#monitors[@]} -gt 0 ]]; then
        internal_monitor="${monitors[0]}"
    fi

    echo "Internal monitor: $internal_monitor"
    echo "External monitors: ${external_monitors[*]}"

    # Отключаем все мониторы сначала
    for monitor in "${monitors[@]}"; do
        xrandr --output "$monitor" --off
    done
    sleep 1

    # Кол-во мониторов
    local count=${#monitors[@]}

    if (( count > 1 )); then
        echo "Multiple monitors detected — assigning 3 desktops per monitor."

        local prev_monitor=""

        for i in "${!monitors[@]}"; do
            local monitor="${monitors[$i]}"
            local mode=$(xrandr | grep -A1 "^$monitor connected" | tail -1 | awk '{print $1}')
            [[ -z "$mode" ]] && mode="1920x1080"

            if (( i == 0 )); then
                # Первый монитор — основной, позиция 0x0
                xrandr --output "$monitor" --primary --mode "$mode" --pos 0x0 --rotate normal
                prev_monitor="$monitor"
            else
                # Последующие — справа от предыдущего
                xrandr --output "$monitor" --mode "$mode" --right-of "$prev_monitor" --rotate normal
                prev_monitor="$monitor"
            fi
            sleep 1
        done

        # Настраиваем bspwm: каждому монитору по 3 рабочих стола
        for monitor in "${monitors[@]}"; do
            bspc monitor "$monitor" -r all 2>/dev/null || true
        done

        local desktop_num=1
        for monitor in "${monitors[@]}"; do
            bspc monitor "$monitor" -d $desktop_num $((desktop_num+1)) $((desktop_num+2))
            desktop_num=$((desktop_num+3))
        done

    else
        echo "Single monitor detected — assigning all desktops to it."

        local monitor="${monitors[0]}"
        local mode=$(xrandr | grep -A1 "^$monitor connected" | tail -1 | awk '{print $1}')
        [[ -z "$mode" ]] && mode="1920x1080"

        xrandr --output "$monitor" --primary --mode "$mode" --pos 0x0 --rotate normal
        sleep 1

        bspc monitor "$monitor" -r all 2>/dev/null || true
        bspc monitor "$monitor" -d 1 2 3 4 5 6
    fi

    # Настройки курсора
    bspc config focus_follows_pointer true
    bspc config pointer_follows_focus false
    bspc config pointer_follows_monitor true

    # Обои
    if command -v feh &> /dev/null; then
        feh --bg-fill --no-fehbg ~/.config/wallpaper.jpg 2>/dev/null || true
    fi

    # Запуск Polybar
    if command -v polybar &> /dev/null; then
        pkill -f "polybar top" 2>/dev/null || true
        sleep 1

        for monitor in "${monitors[@]}"; do
            echo "Starting polybar on $monitor"
            MONITOR="$monitor" polybar top &
            sleep 0.5
        done
    fi

    echo "Monitor setup completed"
}

main
