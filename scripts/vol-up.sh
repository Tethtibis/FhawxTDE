#!/usr/bin/env bash
# Quick volume adjustment: Up 5%
amixer sset Master 5%+ >/dev/null 2>&1 || amixer -D pulse set Master 5%+ >/dev/null 2>&1 || true
VOL=$(amixer get Master 2>/dev/null | grep -oP '\d+%' | head -n 1)
echo "Volume: ${VOL:-OK}"
