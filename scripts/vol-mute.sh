#!/usr/bin/env bash
# Quick volume toggle: Mute / Unmute
amixer sset Master toggle >/dev/null 2>&1 || amixer -D pulse set Master toggle >/dev/null 2>&1 || true
STATUS=$(amixer get Master 2>/dev/null | grep -oP '\[(on|off)\]' | head -n 1)
echo "Audio state: ${STATUS:-toggled}"
