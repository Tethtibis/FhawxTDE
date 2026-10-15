#!/usr/bin/env bash
# ==============================================================================
# FHAWX-DECK TDE // ZERO-DEPENDENCY NETWORK BANDWIDTH TEST
# Uses standard curl to test download throughput without Ookla/speedtest-cli
# ==============================================================================

TEST_URL="https://speed.cloudflare.com/__down?bytes=25000000" # 25MB test payload

echo "Testing download throughput via Cloudflare CDN (25MB payload)..."
SPEED_BYTES=$(curl -s -w "%{speed_download}" -o /dev/null "$TEST_URL")

if [ -n "$SPEED_BYTES" ]; then
    SPEED_MBPS=$(awk "BEGIN {printf \"%.2f\", $SPEED_BYTES * 8 / 1000000}")
    SPEED_MBYTES=$(awk "BEGIN {printf \"%.2f\", $SPEED_BYTES / 1048576}")
    echo ""
    echo "=========================================="
    echo "  DOWNLOAD SPEED : ${SPEED_MBPS} Mbit/s"
    echo "  THROUGHPUT     : ${SPEED_MBYTES} MB/s"
    echo "=========================================="
else
    echo "[-] Speed test failed. Check internet connectivity."
fi
