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

# Основная функция настройки
main() {
    # Получаем список подключенных мониторов
    local monitors=($(detect_monitors))
    echo "Detected monitors: ${monitors[*]}"

    # Разделяем на внутренние и внешние
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

    # Сценарий 1: Есть внешние мониторы
    if [[ ${#external_monitors[@]} -gt 0 ]]; then
        echo "Setting up with external monitors..."

        # Сначала отключаем все мониторы
        for monitor in "${monitors[@]}"; do
            xrandr --output "$monitor" --off
        done
        sleep 1

        # Включаем мониторы в правильном порядке
        local prev_monitor=""

        for i in "${!external_monitors[@]}"; do
            local external="${external_monitors[$i]}"
            local mode=$(xrandr | grep -A1 "^$external connected" | tail -1 | awk '{print $1}')
            [[ -z "$mode" ]] && mode="1920x1080"

            if [[ $i -eq 0 ]]; then
                # Первый внешний монитор - основной
                if [[ -n "$internal_monitor" ]]; then
                    xrandr --output "$external" --primary --mode "$mode" --pos 0x0 --rotate normal \
                           --output "$internal_monitor" --mode 1920x1080 --right-of "$external" --rotate normal
                    prev_monitor="$external"
                else
                    xrandr --output "$external" --primary --mode "$mode" --pos 0x0 --rotate normal
                    prev_monitor="$external"
                fi
            else
                # Дополнительные внешние мониторы
                xrandr --output "$external" --mode "$mode" --right-of "$prev_monitor" --rotate normal
                prev_monitor="$external"
            fi
            sleep 1
        done

        # Если есть внутренний монитор и он еще не настроен
        if [[ -n "$internal_monitor" ]] && ! xrandr | grep -q "^$internal_monitor connected [0-9]"; then
            xrandr --output "$internal_monitor" --mode 1920x1080 --right-of "$prev_monitor" --rotate normal
        fi

        sleep 2

        # Настраиваем bspwm рабочие столы
        # Очищаем все мониторы
        for monitor in "${monitors[@]}"; do
            bspc monitor "$monitor" -r all 2>/dev/null || true
        done

        # Создаем рабочие столы для внешних мониторов
        for external in "${external_monitors[@]}"; do
            bspc monitor "$external" -d 1 2 3
        done

        # Создаем рабочие столы для внутреннего монитора
        if [[ -n "$internal_monitor" ]]; then
            bspc monitor "$internal_monitor" -d 4 5 6
        fi

        # Устанавливаем порядок мониторов
        if [[ ${#external_monitors[@]} -gt 0 ]] && [[ -n "$internal_monitor" ]]; then
            bspc wm --reorder-monitors "${external_monitors[@]}" "$internal_monitor"
        fi

    # Сценарий 2: Только внутренний монитор
    else
        echo "Setting up with internal monitor only..."

        # Отключаем все кроме внутреннего
        for monitor in "${monitors[@]}"; do
            if [[ "$monitor" != "$internal_monitor" ]]; then
                xrandr --output "$monitor" --off
            fi
        done

        # Настраиваем внутренний монитор
        xrandr --output "$internal_monitor" --primary --mode 1920x1080 --pos 0x0 --rotate normal
        sleep 2

        # Очищаем и создаем рабочие столы
        bspc monitor "$internal_monitor" -r all 2>/dev/null || true
        bspc monitor "$internal_monitor" -d 1 2 3 4 5 6
    fi

    # Настройки для перемещения курсора между мониторами
    bspc config focus_follows_pointer true
    bspc config pointer_follows_focus false
    bspc config pointer_follows_monitor true

    # Настройка обоев
    if command -v feh &> /dev/null; then
        feh --bg-fill --no-fehbg ~/.config/wallpaper.jpg 2>/dev/null || true
    fi

    # Запуск полибара
    if command -v polybar &> /dev/null; then
        # Убиваем старые полибары
        pkill -f "polybar top" 2>/dev/null || true
        sleep 1

        # Запускаем на каждом мониторе
        for monitor in "${monitors[@]}"; do
            echo "Starting polybar on $monitor"
            MONITOR="$monitor" polybar top &
            sleep 0.5
        done
    fi

    echo "Monitor setup completed"
}

# Запуск
main
