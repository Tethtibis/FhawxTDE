#!/usr/bin/env bash
# ==============================================================================
# FHAWX-DECK TDE // UNIVERSAL INSTALLER ENTRYPOINT
# Target: Debian 12/13, Ubuntu, Linux Mint, ChromeOS, Netbooks & Servers
# Aesthetic: Monochromatic Burnt Orange (#CC5500)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/deploy_fhawx_deck.sh" ]; then
    echo "[*] Local deployment script detected."
    exec bash "$SCRIPT_DIR/deploy_fhawx_deck.sh" "$@"
else
    echo "[*] Fetching latest FhawxTDE installer payload from GitHub..."
    TMP_SCRIPT=$(mktemp /tmp/fhawx_deploy_XXXXXX.sh)
    curl -fsSL "https://raw.githubusercontent.com/Tethtibis/FhawxTDE/main/deploy_fhawx_deck.sh" -o "$TMP_SCRIPT"
    chmod +x "$TMP_SCRIPT"
    exec bash "$TMP_SCRIPT" "$@"
fi
