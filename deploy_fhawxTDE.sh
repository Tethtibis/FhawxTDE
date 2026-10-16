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
    echo "[+] Configuring rootless Xorg and Libinput touchpad rules for Kiosk Mode..."
    mkdir -p /etc/X11 /etc/X11/xorg.conf.d
    cat << 'EOF' > /etc/X11/Xwrapper.config
allowed_users=anybody
needs_root_rights=yes
EOF
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
