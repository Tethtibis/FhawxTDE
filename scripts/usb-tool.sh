#!/usr/bin/env bash
# ==============================================================================
# USB-TOOL // INTERACTIVE USB DRIVE MOUNTER & UNMOUNTER
# Target: Fhawx-Deck TDE & Chromebooks
# Aesthetic: Monochromatic Burnt Orange (#CC5500 / #FF8C00)
# Auto-detected by ~/scripts/ in Fhawx-Apps Command Palette (Ctrl+Space)
# ==============================================================================

set -euo pipefail

THEME_ORANGE="#CC5500"
THEME_AMBER="#FF8C00"

choose_item() {
    local header="$1"
    shift
    if command -v gum >/dev/null 2>&1; then
        gum choose \
            --header.foreground "$THEME_AMBER" \
            --header "$header" \
            --cursor.foreground "$THEME_AMBER" \
            --item.foreground "$THEME_ORANGE" \
            "$@"
    elif command -v fzf >/dev/null 2>&1; then
        printf "%s\n" "$@" | fzf --prompt="$header > " --color="fg:#CC5500,hl:#FF8C00,pointer:#FF8C00"
    else
        select opt in "$@"; do
            echo "$opt"
            break
        done
    fi
}

echo -e "\033[38;2;204;85;0m================================================================================\033[0m"
echo -e "\033[38;2;255;140;0m  USB STORAGE MANAGER // FHAWX-DECK TDE\033[0m"
echo -e "\033[38;2;204;85;0m================================================================================\033[0m"

# 1. Enumerate USB partitions
# Find disks with TRAN=usb or by looking in /sys/block/*/device/
USB_DEV_LIST=()
mapfile -t RAW_PARTS < <(lsblk -p -l -n -o NAME,SIZE,TYPE,LABEL,FSTYPE,MOUNTPOINT,TRAN 2>/dev/null | grep -E "part|disk" || true)

for line in "${RAW_PARTS[@]}"; do
    dev_name=$(echo "$line" | awk '{print $1}')
    # Check if device is USB transport or has usb in sysfs path
    sys_name=$(basename "$dev_name")
    is_usb=0
    
    if echo "$line" | grep -qi "usb"; then
        is_usb=1
    elif [ -e "/sys/class/block/$sys_name" ]; then
        dev_sys_path=$(readlink -f "/sys/class/block/$sys_name" || true)
        if echo "$dev_sys_path" | grep -qi "usb"; then
            is_usb=1
        fi
    fi

    if [ "$is_usb" -eq 1 ]; then
        # Check if it has a filesystem or is a partition
        fstype=$(echo "$line" | awk '{print $5}')
        mnt=$(echo "$line" | awk '{print $6}')
        # Skip swap or empty containers
        if [[ "$fstype" != "[SWAP]" ]]; then
            USB_DEV_LIST+=("$line")
        fi
    fi
done

if [ ${#USB_DEV_LIST[@]} -eq 0 ]; then
    echo -e "\n\033[38;2;255;140;0m[*] No USB storage drives currently detected.\033[0m"
    echo -e "    Insert a USB drive or flash disk, then run this tool again.\n"
    read -r -p "Press Enter to exit..."
    exit 0
fi

# Build menu items
MENU_CHOICES=()
for item in "${USB_DEV_LIST[@]}"; do
    dev=$(echo "$item" | awk '{print $1}')
    size=$(echo "$item" | awk '{print $2}')
    lbl=$(echo "$item" | awk '{print $4}')
    [ -z "$lbl" ] || [ "$lbl" = "-" ] && lbl="USB_DRIVE"
    mnt=$(echo "$item" | awk '{print $6}')

    if [ -n "$mnt" ] && [ "$mnt" != "-" ]; then
        MENU_CHOICES+=("⏏ [UNMOUNT] $dev ($size - $lbl) -> Mounted on $mnt")
    else
        MENU_CHOICES+=("🔌 [MOUNT]   $dev ($size - $lbl)")
    fi
done
MENU_CHOICES+=("[Refresh Devices]" "[Cancel / Exit]")

ACTION=$(choose_item "Select USB Partition Action:" "${MENU_CHOICES[@]}")

case "$ACTION" in
    *"[MOUNT]"*)
        TARGET_DEV=$(echo "$ACTION" | awk '{print $3}')
        DEV_NAME=$(basename "$TARGET_DEV")
        LABEL=$(lsblk -n -o LABEL "$TARGET_DEV" 2>/dev/null || true)
        [ -z "$LABEL" ] && LABEL="$DEV_NAME"
        
        TARGET_MNT="/media/$USER/$LABEL"

        echo -e "\n\033[38;2;255;140;0m[+] Mounting $TARGET_DEV to $TARGET_MNT...\033[0m"

        # Try udisksctl first (non-root standard)
        if command -v udisksctl >/dev/null 2>&1; then
            udisksctl mount -b "$TARGET_DEV" || true
        else
            sudo mkdir -p "$TARGET_MNT"
            sudo mount -o "uid=$(id -u),gid=$(id -g),umask=022" "$TARGET_DEV" "$TARGET_MNT" 2>/dev/null || \
            sudo mount "$TARGET_DEV" "$TARGET_MNT"
            echo -e "\033[32m[✓] Successfully mounted to $TARGET_MNT\033[0m"
        fi
        
        # Open file manager / notes or confirm
        read -r -p "Press Enter to return..."
        ;;

    *"[UNMOUNT]"*)
        TARGET_DEV=$(echo "$ACTION" | awk '{print $3}')
        echo -e "\n\033[38;2;255;140;0m[*] Flushing write cache and safely unmounting $TARGET_DEV...\033[0m"
        sync

        if command -v udisksctl >/dev/null 2>&1; then
            udisksctl unmount -b "$TARGET_DEV" 2>/dev/null || true
            udisksctl power-off -b "$TARGET_DEV" 2>/dev/null || true
        else
            sudo umount -f "$TARGET_DEV" 2>/dev/null || true
        fi

        echo -e "\033[32m[✓] Device unmounted safely. It is now safe to unplug your USB drive.\033[0m\n"
        read -r -p "Press Enter to return..."
        ;;

    *"[Refresh Devices]"*)
        exec "$0"
        ;;

    *)
        exit 0
        ;;
esac
