#!/bin/bash

# Получаем default route (интерфейс + основной src IP)
ROUTE_INFO=$(ip route get 1.1.1.1 2>/dev/null)

INTERFACE=$(awk '{for (i=1;i<=NF;i++) if ($i=="dev") print $(i+1)}' <<< "$ROUTE_INFO")
IP_ADDRESS=$(awk '{for (i=1;i<=NF;i++) if ($i=="src") print $(i+1)}' <<< "$ROUTE_INFO")

# Внешний IP
EXTERNAL_IP=$(curl -s --max-time 3 https://api.ipify.org || true)

# Формируем сообщение
MESSAGE="Interface: ${INTERFACE:-unknown}
Local IP: ${IP_ADDRESS:-not found}"

if [[ -n "$EXTERNAL_IP" ]]; then
    MESSAGE="$MESSAGE
External IP: $EXTERNAL_IP"
fi

# Уведомление
notify-send -t 5000 "Network Information" "$MESSAGE"

# Копируем основной локальный IP
if command -v xclip &>/dev/null && [[ -n "$IP_ADDRESS" ]]; then
    echo -n "$IP_ADDRESS" | xclip -selection clipboard
fi
