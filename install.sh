#!/usr/bin/env bash
# ==============================================================================
# FHAWXTDE // UNIVERSAL INSTALLER ENTRYPOINT
# Target: Debian 12/13, Ubuntu, Linux Mint, ChromeOS, Netbooks & SSH Servers
# Modes:
#   Default (no flags) : On-Demand CLI / SSH Mode (Type 'fhawx' or 'tde' anytime)
#   --kiosk            : Full Dedicated Netbook Kiosk Mode (Auto-boot into TDE)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/deploy_fhawxTDE.sh" ]; then
    echo "[*] Local deployment script detected."
    exec bash "$SCRIPT_DIR/deploy_fhawxTDE.sh" "$@"
else
    echo "[*] Fetching latest FhawxTDE installer payload from GitHub..."
    TMP_SCRIPT=$(mktemp /tmp/fhawxTDE_deploy_XXXXXX.sh)
    curl -fsSL "https://raw.githubusercontent.com/Tethtibis/FhawxTDE/main/deploy_fhawxTDE.sh" -o "$TMP_SCRIPT"
    chmod +x "$TMP_SCRIPT"
    exec bash "$TMP_SCRIPT" "$@"
fi
