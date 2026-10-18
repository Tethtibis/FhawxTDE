#!/usr/bin/env bash
# ==============================================================================
# FHAWXTDE // AUTOMATED PROVISIONER & DEPLOYER
# Target: Any Debian 12/13, Ubuntu, Linux Mint, WSL, SSH Server, or Retro Netbook
# Aesthetic: Monochromatic Burnt Orange (#CC5500)
# Modes:
#   Default (On-Demand CLI / "DOS Shell" Mode):
#     Installs pure terminal stack & 'fhawx' / 'tde' command. Works locally or
#     over SSH without hijacking your desktop environment or installing Xorg.
#   --kiosk (Dedicated Netbook Kiosk Mode):
#     Adds Micro-X11 kiosk layer and auto-starts FhawxTDE on /dev/tty1 login.
# ==============================================================================

set -euo pipefail

# 1. Parse Arguments (--kiosk vs default CLI mode)
KIOSK_MODE=0
TARGET_USER_ARG=""

for arg in "$@"; do
    case "$arg" in
        --kiosk|-k)
            KIOSK_MODE=1
            ;;
        --cli|-c)
            KIOSK_MODE=0
            ;;
        -h|--help)
            echo "Usage: sudo ./deploy_fhawxTDE.sh [--cli | --kiosk] [username]"
            echo "  --cli    (Default) On-Demand CLI/SSH mode. Type 'fhawx' or 'tde' in any terminal."
            echo "  --kiosk  Dedicated Netbook mode. Installs Micro-X11 and auto-starts on TTY1."
            exit 0
            ;;
        *)
            TARGET_USER_ARG="$arg"
            ;;
    esac
done

# 2. Identity Verification & Self-Elevating Sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "[*] Sudo elevation required. Prompting for administrator password..."
    exec sudo -E bash "$0" "$@"
fi

if [ -n "$TARGET_USER_ARG" ]; then
    TARGET_USER="$TARGET_USER_ARG"
elif [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
    TARGET_USER="$SUDO_USER"
else
    TARGET_USER=$(awk -F: '$3 >= 1000 && $3 < 65534 {print $1; exit}' /etc/passwd || true)
    [ -z "$TARGET_USER" ] && TARGET_USER="root"
fi

TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
if [ "$KIOSK_MODE" -eq 1 ]; then
    echo "[+] Deploying FhawxTDE [KIOSK DESKTOP MODE] for operator: $TARGET_USER ($TARGET_HOME)"
else
    echo "[+] Deploying FhawxTDE [ON-DEMAND CLI / SSH MODE] for operator: $TARGET_USER ($TARGET_HOME)"
fi

export DEBIAN_FRONTEND=noninteractive

# 3. Asset Discovery & Embedded Payload Extraction
SCRIPT_SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMP_ASSET_DIR=""

if [ ! -d "$SCRIPT_SRC_DIR/bin" ] || [ ! -d "$SCRIPT_SRC_DIR/conf" ] || [ ! -d "$SCRIPT_SRC_DIR/scripts" ]; then
    echo "[*] Standalone execution detected (local asset subdirectories not found)."
    echo "[+] Unpacking embedded FhawxTDE assets..."
    TEMP_ASSET_DIR=$(mktemp -d /tmp/fhawx_assets_XXXXXX)
    base64 -d << 'EOF_EMBEDDED_ASSETS' | tar -xzf - -C "$TEMP_ASSET_DIR"
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
EOF_EMBEDDED_ASSETS
    SCRIPT_SRC_DIR="$TEMP_ASSET_DIR"
    trap '[ -n "$TEMP_ASSET_DIR" ] && rm -rf "$TEMP_ASSET_DIR"' EXIT
fi

# Clean up any broken Charm.sh repository/keyring from prior runs
rm -f /etc/apt/sources.list.d/charm.list /etc/apt/keyrings/charm.gpg

# 4. APT Package Installation
echo "[+] Updating APT package indexes..."
apt-get update -y

CLI_PKGS=(
    tmux
    micro
    btop
    fzf
    curl
    git
    alsa-utils
    network-manager
    wireguard
    wireguard-tools
    ca-certificates
    python3
)

echo "[+] Installing core FhawxTDE terminal & network packages..."
apt-get install -y --no-install-recommends "${CLI_PKGS[@]}"

if [ "$KIOSK_MODE" -eq 1 ]; then
    echo "[+] Installing Micro-X11 Kiosk stack (--kiosk enabled)..."
    KIOSK_PKGS=(
        xserver-xorg
        xserver-xorg-legacy
        x11-xserver-utils
        xinit
        matchbox-window-manager
        xfce4-terminal
        unclutter
        redshift
        fonts-dejavu-core
        fonts-terminus
    )
    apt-get install -y --no-install-recommends "${KIOSK_PKGS[@]}"
fi

echo "[+] Installing recommended CLI utilities (fastfetch, tealdeer, lldpd, dialog)..."
OPTIONAL_PKGS=(
    fastfetch
    tealdeer
    tldr
    lldpd
    dialog
)

for pkg in "${OPTIONAL_PKGS[@]}"; do
    apt-get install -y --no-install-recommends "$pkg" 2>/dev/null || true
done

# 5. Install Gum TUI (Direct Standalone Deb)
if ! command -v gum >/dev/null 2>&1; then
    echo "[+] Downloading and installing Charm Gum TUI (standalone)..."
    GUM_URL="https://github.com/charmbracelet/gum/releases/download/v0.14.5/gum_0.14.5_amd64.deb"
    if curl -fsSL "$GUM_URL" -o /tmp/gum.deb 2>/dev/null; then
        dpkg -i /tmp/gum.deb 2>/dev/null || apt-get install -f -y 2>/dev/null || true
        rm -f /tmp/gum.deb
    else
        echo "[!] Notice: Gum download skipped; fzf active as default selector."
    fi
fi

# 6. Hardware Groups & Permissions
echo "[+] Configuring user permissions and network privileges..."
for grp in netdev audio video input plugdev; do
    if getent group "$grp" >/dev/null; then
        usermod -aG "$grp" "$TARGET_USER" || true
    fi
done

echo "[+] Installing NetworkManager polkit rules..."
mkdir -p /etc/polkit-1/rules.d
if [ -f "$SCRIPT_SRC_DIR/conf/10-networkmanager.rules" ]; then
    cp -f "$SCRIPT_SRC_DIR/conf/10-networkmanager.rules" /etc/polkit-1/rules.d/10-networkmanager.rules
fi

# Passwordless WireGuard and Netcheck (LLDP) execution
echo "$TARGET_USER ALL=(ALL) NOPASSWD: /usr/bin/wg-quick, /usr/bin/wg, /usr/sbin/lldpctl, /usr/sbin/lldpcli" > /etc/sudoers.d/fhawx-privs
chmod 0440 /etc/sudoers.d/fhawx-privs
systemctl enable --now lldpd 2>/dev/null || true

if [ "$KIOSK_MODE" -eq 1 ]; then
    echo "[+] Configuring rootless Xorg, modesetting ShadowFB, and Libinput touchpad rules for Kiosk Mode..."
    mkdir -p /etc/X11 /etc/X11/xorg.conf.d
    cat << 'EOF' > /etc/X11/Xwrapper.config
allowed_users=anybody
needs_root_rights=yes
EOF
    if [ -f "$SCRIPT_SRC_DIR/conf/20-modesetting.conf" ]; then
        cp -f "$SCRIPT_SRC_DIR/conf/20-modesetting.conf" /etc/X11/xorg.conf.d/20-modesetting.conf
    else
        cat << 'EOF' > /etc/X11/xorg.conf.d/20-modesetting.conf
Section "Device"
    Identifier "Fhawx-Kiosk-GPU"
    Driver "modesetting"
    Option "AccelMethod" "none"
EndSection
EOF
    fi
    if [ -f "$SCRIPT_SRC_DIR/conf/40-libinput.conf" ]; then
        cp -f "$SCRIPT_SRC_DIR/conf/40-libinput.conf" /etc/X11/xorg.conf.d/40-libinput.conf
    fi
fi

# 7. Audio Codec Initialization
amixer sset Master unmute 75% 2>/dev/null || true
amixer sset Headphone unmute 100% 2>/dev/null || true
amixer sset Speaker unmute 100% 2>/dev/null || true
alsactl store 2>/dev/null || true

# 8. Deploy Scripts & Configs to Target User and Global CLI Path
BIN_DEST="$TARGET_HOME/.local/bin"
FHAWX_CONF_DIR="$TARGET_HOME/.config/fhawx"
mkdir -p "$BIN_DEST" "$FHAWX_CONF_DIR" "$TARGET_HOME/.config/ssh_station" "$TARGET_HOME/.config/fastfetch" "$TARGET_HOME/scripts" "$TARGET_HOME/Documents" "$TARGET_HOME/wireguard"

echo "[+] Deploying FhawxTDE binaries to $BIN_DEST and /usr/local/bin..."
if [ -d "$SCRIPT_SRC_DIR/bin" ]; then
    find "$SCRIPT_SRC_DIR/bin" -maxdepth 1 -type f -exec cp -f {} "$BIN_DEST/" \;
    chmod +x "$BIN_DEST/"*
    # Install global entrypoints so 'fhawx' and 'tde' work immediately in any shell or SSH session
    cp -f "$BIN_DEST/fhawx" /usr/local/bin/fhawx
    cp -f "$BIN_DEST/tde" /usr/local/bin/tde
    chmod +x /usr/local/bin/fhawx /usr/local/bin/tde
fi

echo "[+] Deploying isolated FhawxTDE Tmux configuration..."
if [ -f "$SCRIPT_SRC_DIR/conf/fhawx-tmux.conf" ]; then
    cp -f "$SCRIPT_SRC_DIR/conf/fhawx-tmux.conf" "$FHAWX_CONF_DIR/tmux.conf"
    # Only populate ~/.tmux.conf if user doesn't have a custom one, or if in dedicated kiosk mode
    if [ ! -f "$TARGET_HOME/.tmux.conf" ] || [ "$KIOSK_MODE" -eq 1 ]; then
        cp -f "$SCRIPT_SRC_DIR/conf/fhawx-tmux.conf" "$TARGET_HOME/.tmux.conf"
    fi
fi

if [ "$KIOSK_MODE" -eq 1 ] && [ -f "$SCRIPT_SRC_DIR/conf/xinitrc" ]; then
    cp -f "$SCRIPT_SRC_DIR/conf/xinitrc" "$TARGET_HOME/.xinitrc"
    chmod +x "$TARGET_HOME/.xinitrc"
fi

# Deploy Fastfetch ASCII Trinity logo & config
if [ -f "$SCRIPT_SRC_DIR/conf/fhawx_logo.txt" ]; then
    cp -f "$SCRIPT_SRC_DIR/conf/fhawx_logo.txt" "$TARGET_HOME/.config/fastfetch/fhawx_logo.txt"
fi
if [ -f "$SCRIPT_SRC_DIR/conf/fhawx_logo_ascii.txt" ]; then
    cp -f "$SCRIPT_SRC_DIR/conf/fhawx_logo_ascii.txt" "$TARGET_HOME/.config/fastfetch/fhawx_logo_ascii.txt"
fi
if [ -f "$SCRIPT_SRC_DIR/conf/fastfetch.jsonc" ]; then
    cp -f "$SCRIPT_SRC_DIR/conf/fastfetch.jsonc" "$TARGET_HOME/.config/fastfetch/config.jsonc"
fi

# Deploy curated user scripts to ~/scripts/
if [ -d "$SCRIPT_SRC_DIR/scripts" ]; then
    echo "[+] Deploying curated helper scripts to $TARGET_HOME/scripts/..."
    find "$SCRIPT_SRC_DIR/scripts" -maxdepth 1 -type f -exec cp -f {} "$TARGET_HOME/scripts/" \;
    chmod +x "$TARGET_HOME/scripts/"*
fi

# Default SSH station hosts if not already created
if [ ! -f "$TARGET_HOME/.config/ssh_station/hosts.json" ]; then
    cat << 'EOF' > "$TARGET_HOME/.config/ssh_station/hosts.json"
{
    "hosts": [
        {
            "name": "Server 1 (Primary)",
            "host": "192.168.1.100",
            "user": "operator",
            "port": 22,
            "auth_type": "key",
            "key_path": "~/.ssh/id_ed25519",
            "password": ""
        },
        {
            "name": "Workstation 2",
            "host": "192.168.1.101",
            "user": "operator",
            "port": 22,
            "auth_type": "key",
            "key_path": "~/.ssh/id_ed25519",
            "password": ""
        },
        {
            "name": "Remote Node 3",
            "host": "192.168.1.102",
            "user": "operator",
            "port": 22,
            "auth_type": "key",
            "key_path": "~/.ssh/id_ed25519",
            "password": ""
        }
    ]
}
EOF
fi

# 9. Shell PATH & Optional Kiosk Autostart Integration
BASHRC="$TARGET_HOME/.bashrc"
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$BASHRC" 2>/dev/null; then
    echo '' >> "$BASHRC"
    echo '# --- FHAWXTDE CLI PATH ---' >> "$BASHRC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$BASHRC"
fi

if [ "$KIOSK_MODE" -eq 1 ]; then
    AUTOSTART_BLOCK=$(cat << 'EOF'

# --- FHAWXTDE KIOSK AUTOSTART ---
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    startx || {
        echo ""
        echo "[!] Xorg session ended with status $?. Check ~/.xsession-errors or /var/log/Xorg.0.log"
        echo "[*] Remaining in bash shell for diagnosis."
    }
fi
EOF
)
    if ! grep -q "FHAWXTDE KIOSK AUTOSTART" "$BASHRC" 2>/dev/null; then
        echo "$AUTOSTART_BLOCK" >> "$BASHRC"
    fi
fi

# Fix ownership
for item in "$TARGET_HOME/.local" "$TARGET_HOME/.tmux.conf" "$TARGET_HOME/.xinitrc" "$TARGET_HOME/.config" "$TARGET_HOME/scripts" "$TARGET_HOME/Documents" "$TARGET_HOME/wireguard" "$BASHRC"; do
    [ -e "$item" ] && chown -R "$TARGET_USER:$TARGET_USER" "$item" 2>/dev/null || true
done

echo ""
echo "================================================================================"
echo "  [✓] FhawxTDE Provisioning Complete!"
echo "================================================================================"
echo "  Operator : $TARGET_USER"
if [ "$KIOSK_MODE" -eq 1 ]; then
    echo "  Mode     : Dedicated Netbook Kiosk (--kiosk)"
    echo "  Launch   : Type 'startx' on TTY1, or type 'fhawx' / 'tde' in any terminal."
else
    echo "  Mode     : On-Demand CLI / SSH ('DOS Shell' Mode)"
    echo "  Launch   : Type 'fhawx' (or 'tde') in any terminal or SSH window!"
    echo "  Return   : Press 'Alt + Q' inside FhawxTDE to drop back to your normal shell."
fi
echo "================================================================================"
