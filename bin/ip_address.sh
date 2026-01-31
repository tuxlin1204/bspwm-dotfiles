#!/bin/bash
iface=$(ip route | grep '^default' | awk '{print $5}' | head -n1)
ip -4 addr show "$iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
