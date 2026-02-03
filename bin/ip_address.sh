#!/bin/bash

# Получаем активные интерфейсы
INTERFACE=$(ip route | grep default | awk '{print $5}')
IP_ADDRESS=$(ip addr show $INTERFACE | grep -oP 'inet \K[\d.]+(?=/\d+)')

# Также получаем внешний IP (если есть интернет)
EXTERNAL_IP=$(curl -s https://api.ipify.org 2>/dev/null || echo "No internet")

MESSAGE="Interface: $INTERFACE
Local IP: $IP_ADDRESS"

if [ -n "$EXTERNAL_IP" ] && [ "$EXTERNAL_IP" != "No internet" ]; then
    MESSAGE="$MESSAGE
External IP: $EXTERNAL_IP"
fi

# Показываем уведомление
notify-send -t 5000 "Network Information" "$MESSAGE"

# Копируем локальный IP в буфер обмена
if command -v xclip &> /dev/null; then
    echo -n "$IP_ADDRESS" | xclip -selection clipboard
fi
