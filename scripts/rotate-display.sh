#!/usr/bin/env bash
# ==============================================================================
# FHAWXTDE // 2-IN-1 SCREEN & TOUCHSCREEN ROTATION SUITE
# Aligns xrandr display with xinput Coordinate Transformation Matrix
# ==============================================================================

if [ -z "${DISPLAY:-}" ]; then
    echo "[-] Error: DISPLAY not set. This tool requires an active X11 session."
    exit 1
fi

# Detect primary active display
DISPLAY_OUT=$(xrandr --query 2>/dev/null | grep " connected" | head -n 1 | cut -d' ' -f1)
if [ -z "$DISPLAY_OUT" ]; then
    DISPLAY_OUT="eDP1"
fi

# Detect touchscreen/stylus device names
TOUCH_DEVS=$(xinput list --name-only 2>/dev/null | grep -iE 'touch|atmel|elan|wacom|synaptics|digitizer' || true)

echo "Active Display Output: $DISPLAY_OUT"
echo "Touchscreen Devices: ${TOUCH_DEVS:-None detected}"
echo ""

apply_matrix() {
    local matrix="$1"
    if [ -n "$TOUCH_DEVS" ]; then
        while IFS= read -r dev; do
            if [ -n "$dev" ]; then
                xinput set-prop "$dev" "Coordinate Transformation Matrix" $matrix 2>/dev/null || true
            fi
        done <<< "$TOUCH_DEVS"
    fi
}

echo "Select Screen Orientation:"
echo "1. Normal (Standard Landscape)"
echo "2. Tablet Mode (Rotate Left 90°)"
echo "3. Portrait Mode (Rotate Right 90°)"
echo "4. Tent Mode (Inverted 180°)"
read -r -p "Enter choice [1-4]: " CHOICE

case "$CHOICE" in
    1)
        xrandr --output "$DISPLAY_OUT" --rotate normal
        apply_matrix "1 0 0 0 1 0 0 0 1"
        echo "[✓] Display set to Normal (Landscape)."
        ;;
    2)
        xrandr --output "$DISPLAY_OUT" --rotate left
        apply_matrix "0 -1 1 1 0 0 0 0 1"
        echo "[✓] Display set to Tablet Mode (Left)."
        ;;
    3)
        xrandr --output "$DISPLAY_OUT" --rotate right
        apply_matrix "0 1 0 -1 0 1 0 0 1"
        echo "[✓] Display set to Portrait Mode (Right)."
        ;;
    4)
        xrandr --output "$DISPLAY_OUT" --rotate inverted
        apply_matrix "-1 0 1 0 -1 1 0 0 1"
        echo "[✓] Display set to Tent Mode (Inverted)."
        ;;
    *)
        echo "Cancelled."
        ;;
esac
