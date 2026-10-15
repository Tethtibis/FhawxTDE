#!/usr/bin/env bash
# ==============================================================================
# FHAWX-DECK TDE // DISPLAY COLOR CALIBRATOR (COOL TINT FIX)
# Neutralizes yellow/warm tint on budget TN netbook panels
# ==============================================================================

if ! command -v redshift >/dev/null 2>&1; then
    echo "Installing redshift utility..."
    sudo apt-get update -y && sudo apt-get install -y redshift
fi

echo "1. Apply Cool 9500K Calibration (Neutralizes yellow TN tint)"
echo "2. Reset Display to Default (Neutral 6500K)"
read -r -p "Select option [1-2]: " OPT

if [ "$OPT" = "1" ]; then
    redshift -O 9500
    echo "[✓] Display color balance calibrated to 9500K Cool White."
else
    redshift -x
    echo "[✓] Display color balance reset to native."
fi
