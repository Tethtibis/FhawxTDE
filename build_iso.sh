#!/usr/bin/env bash
# ==============================================================================
# FHAWX-DECK TDE // UNIVERSAL HYBRID LIVE/INSTALLER ISO BUILDER
# Target Base: Debian 13 (Trixie) amd64
# Execution Node: Headless secondary storage on NecroBeast
# Output: fhawx-deck-trixie-amd64.iso (Ventoy / UEFI / BIOS / VirtualBox)
# ==============================================================================

set -euo pipefail

# ANSI Palette
ORANGE='\033[38;2;204;85;0m'
AMBER='\033[38;2;255;140;0m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${ORANGE}================================================================================${NC}"
echo -e "${AMBER}  FHAWX-DECK TDE // DEBIAN 13 (TRIXIE) LIVE ISO ENGINE${NC}"
echo -e "${ORANGE}================================================================================${NC}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}[-] Must run as root.${NC}" >&2
    exit 1
fi

mount -o remount,dev,suid,exec /mnt/bee9984f-30c1-4140-91a7-f560e1b263da 2>/dev/null || true

WORK_DIR="/mnt/bee9984f-30c1-4140-91a7-f560e1b263da/fhawx-iso-build"
CHROOT_DIR="${WORK_DIR}/chroot"
STAGING_DIR="${WORK_DIR}/staging/fhawx-deck-tde"
ISO_DIR="${WORK_DIR}/iso_root"
OUTPUT_DIR="${WORK_DIR}/output"
DEBIAN_MIRROR="http://deb.debian.org/debian"
KEYRING="/usr/share/keyrings/debian-archive-keyring.gpg"

cleanup_mounts() {
    echo -e "\n${AMBER}[*] Cleaning up mount points...${NC}"
    for m in "${CHROOT_DIR}/dev/pts" "${CHROOT_DIR}/dev" "${CHROOT_DIR}/proc" "${CHROOT_DIR}/sys" "${CHROOT_DIR}/run"; do
        if mountpoint -q "$m" 2>/dev/null; then
            umount -lf "$m" 2>/dev/null || true
        fi
    done
}
trap cleanup_mounts EXIT INT TERM

mkdir -p "${WORK_DIR}" "${ISO_DIR}/live" "${ISO_DIR}/boot/grub" "${OUTPUT_DIR}" "${STAGING_DIR}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo -e "${AMBER}[*] Synchronizing staging assets from ${SCRIPT_DIR}...${NC}"
cp -rf "${SCRIPT_DIR}/bin" "${SCRIPT_DIR}/conf" "${SCRIPT_DIR}/scripts" "${STAGING_DIR}/"

# ------------------------------------------------------------------------------
# STEP 1: Debootstrap Debian 13 (Trixie)
# ------------------------------------------------------------------------------
if [ ! -f "${CHROOT_DIR}/bin/bash" ]; then
    echo -e "${AMBER}[1/6] Bootstrapping Debian 13 (Trixie) base system...${NC}"
    rm -rf "${CHROOT_DIR}"
    mkdir -p "${CHROOT_DIR}"
    debootstrap \
        --arch=amd64 \
        --keyring="${KEYRING}" \
        --components=main,contrib,non-free,non-free-firmware \
        trixie \
        "${CHROOT_DIR}" \
        "${DEBIAN_MIRROR}"
else
    echo -e "${GREEN}[1/6] Base debootstrap system already present. Re-using.${NC}"
fi

# ------------------------------------------------------------------------------
# STEP 2: Configure Repositories & Mounts
# ------------------------------------------------------------------------------
echo -e "${AMBER}[2/6] Configuring repositories and mounting pseudo-filesystems...${NC}"
cat << 'EOF' > "${CHROOT_DIR}/etc/apt/sources.list"
deb http://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware
EOF

cat << 'EOF' > "${CHROOT_DIR}/etc/apt/apt.conf.d/99no-recommends"
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

# Host resolution inside chroot
cp -L /etc/resolv.conf "${CHROOT_DIR}/etc/resolv.conf"

# Bind pseudo filesystems
mount --bind /dev "${CHROOT_DIR}/dev"
mount --bind /dev/pts "${CHROOT_DIR}/dev/pts"
mount -t proc proc "${CHROOT_DIR}/proc"
mount -t sysfs sys "${CHROOT_DIR}/sys"
mount -t tmpfs tmpfs "${CHROOT_DIR}/run"

# ------------------------------------------------------------------------------
# STEP 3: Install Kernel, Live System, Hardware & TDE Packages
# ------------------------------------------------------------------------------
echo -e "${AMBER}[3/6] Installing kernel, live-boot, firmware, and Fhawx-Deck core packages...${NC}"

export DEBIAN_FRONTEND=noninteractive

chroot "${CHROOT_DIR}" apt-get update -y

chroot "${CHROOT_DIR}" apt-get install -y --no-install-recommends \
    linux-image-amd64 \
    live-boot \
    live-config \
    live-config-systemd \
    systemd-sysv \
    firmware-linux-free \
    firmware-misc-nonfree \
    firmware-iwlwifi \
    firmware-realtek \
    firmware-atheros \
    firmware-sof-signed \
    intel-microcode \
    amd64-microcode \
    pciutils \
    usbutils \
    e2fsprogs \
    dosfstools \
    parted \
    util-linux \
    rsync \
    efibootmgr \
    grub-pc-bin \
    grub-efi-amd64-bin \
    grub2-common \
    open-vm-tools \
    qemu-guest-agent \
    xserver-xorg \
    xserver-xorg-legacy \
    x11-xserver-utils \
    xinit \
    matchbox-window-manager \
    xfce4-terminal \
    tmux \
    micro \
    btop \
    fzf \
    fastfetch \
    alsa-utils \
    network-manager \
    wpasupplicant \
    wireguard \
    wireguard-tools \
    unclutter \
    tealdeer \
    lldpd \
    curl \
    git \
    wget \
    ca-certificates \
    dialog \
    locales \
    sudo \
    less \
    bash-completion \
    fonts-dejavu-core \
    fonts-terminus \
    redshift \
    python3 \
    python3-minimal

# Install Charm Gum TUI binary
if ! chroot "${CHROOT_DIR}" command -v gum >/dev/null 2>&1; then
    echo -e "${AMBER}  -> Downloading and installing Charm Gum TUI...${NC}"
    curl -sSL https://github.com/charmbracelet/gum/releases/download/v0.14.5/gum_0.14.5_amd64.deb -o "${CHROOT_DIR}/tmp/gum.deb"
    chroot "${CHROOT_DIR}" dpkg -i /tmp/gum.deb || true
    rm -f "${CHROOT_DIR}/tmp/gum.deb"
fi

# Locale & Timezone
echo "en_US.UTF-8 UTF-8" > "${CHROOT_DIR}/etc/locale.gen"
chroot "${CHROOT_DIR}" locale-gen
echo "LANG=en_US.UTF-8" > "${CHROOT_DIR}/etc/default/locale"

# Hostname
echo "fhawx-deck" > "${CHROOT_DIR}/etc/hostname"
cat << 'EOF' > "${CHROOT_DIR}/etc/hosts"
127.0.0.1   localhost
127.0.1.1   fhawx-deck
::1         ip6-localhost ip6-loopback
EOF

# Xwrapper permissions (root rights required for direct VT console access in Debian 13)
cat << 'EOF' > "${CHROOT_DIR}/etc/X11/Xwrapper.config"
allowed_users=anybody
needs_root_rights=yes
EOF

# NetworkManager Configuration
cat << 'EOF' > "${CHROOT_DIR}/etc/NetworkManager/NetworkManager.conf"
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
EOF

# Polkit & Libinput rules
mkdir -p "${CHROOT_DIR}/etc/polkit-1/rules.d" "${CHROOT_DIR}/etc/X11/xorg.conf.d"
cp -f "${STAGING_DIR}/conf/10-networkmanager.rules" "${CHROOT_DIR}/etc/polkit-1/rules.d/10-networkmanager.rules"
cp -f "${STAGING_DIR}/conf/40-libinput.conf" "${CHROOT_DIR}/etc/X11/xorg.conf.d/40-libinput.conf"

# Live Config Parameters
mkdir -p "${CHROOT_DIR}/etc/live"
cat << 'EOF' > "${CHROOT_DIR}/etc/live/config.conf"
LIVE_HOSTNAME="fhawx-deck"
LIVE_USERNAME="fhawx"
LIVE_USER_FULLNAME="Fhawx Operator"
LIVE_USER_DEFAULT_GROUPS="sudo,netdev,audio,video,input,dialout,plugdev"
EOF

# Pre-create user fhawx with password fhawx
if ! chroot "${CHROOT_DIR}" id fhawx >/dev/null 2>&1; then
    chroot "${CHROOT_DIR}" useradd -m -s /bin/bash -G sudo,netdev,audio,video,input,dialout,plugdev fhawx
    echo "fhawx:fhawx" | chroot "${CHROOT_DIR}" chpasswd
fi

# Passwordless sudo for fhawx
echo "fhawx ALL=(ALL:ALL) NOPASSWD: ALL" > "${CHROOT_DIR}/etc/sudoers.d/fhawx"
chmod 0440 "${CHROOT_DIR}/etc/sudoers.d/fhawx"

# Configure Autologin on TTY1
mkdir -p "${CHROOT_DIR}/etc/systemd/system/getty@tty1.service.d"
cat << 'EOF' > "${CHROOT_DIR}/etc/systemd/system/getty@tty1.service.d/autologin.conf"
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin fhawx --noclear %I $TERM
EOF

# Enable NetworkManager & LLDP
chroot "${CHROOT_DIR}" systemctl enable NetworkManager lldpd 2>/dev/null || true

# ------------------------------------------------------------------------------
# STEP 4: Inject Fhawx-Deck TDE Scripts & Configs
# ------------------------------------------------------------------------------
echo -e "${AMBER}[4/6] Injecting Fhawx-Deck TDE configurations and scripts...${NC}"

# Target user home & skel setup
for target_base in "${CHROOT_DIR}/home/fhawx" "${CHROOT_DIR}/etc/skel"; do
    mkdir -p "${target_base}/.local/bin" \
             "${target_base}/.config/ssh_station" \
             "${target_base}/.config/fastfetch" \
             "${target_base}/scripts" \
             "${target_base}/Documents" \
             "${target_base}/wireguard"

    find "${STAGING_DIR}/bin" -maxdepth 1 -type f -exec cp -f {} "${target_base}/.local/bin/" \;
    chmod +x "${target_base}/.local/bin/"*

    cp -f "${STAGING_DIR}/conf/fhawx-tmux.conf" "${target_base}/.tmux.conf"
    cp -f "${STAGING_DIR}/conf/xinitrc" "${target_base}/.xinitrc"
    chmod +x "${target_base}/.xinitrc"

    if [ -f "${STAGING_DIR}/conf/fhawx_logo.txt" ]; then
        cp -f "${STAGING_DIR}/conf/fhawx_logo.txt" "${target_base}/.config/fastfetch/fhawx_logo.txt"
    fi
    if [ -f "${STAGING_DIR}/conf/fastfetch.jsonc" ]; then
        cp -f "${STAGING_DIR}/conf/fastfetch.jsonc" "${target_base}/.config/fastfetch/config.jsonc"
    fi

    if [ -d "${STAGING_DIR}/scripts" ]; then
        find "${STAGING_DIR}/scripts" -maxdepth 1 -type f -exec cp -f {} "${target_base}/scripts/" \;
        chmod +x "${target_base}/scripts/"*
    fi

    # SSH Station hosts
    if [ ! -f "${target_base}/.config/ssh_station/hosts.json" ]; then
        cat << 'EOF' > "${target_base}/.config/ssh_station/hosts.json"
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

    # Autostart X on TTY1 login (safe execution without instant kickback)
    BASHRC="${target_base}/.bashrc"
    if ! grep -q "FHAWX-DECK TDE AUTOSTART" "$BASHRC" 2>/dev/null; then
        cat << 'EOF' >> "$BASHRC"

# --- FHAWX-DECK TDE AUTOSTART ---
export PATH="$HOME/.local/bin:$PATH"
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    startx || {
        echo ""
        echo "[!] Xorg session ended with status $?. Check ~/.xsession-errors or /var/log/Xorg.0.log"
        echo "[*] Remaining in bash shell for diagnosis."
    }
fi
EOF
    fi
done

# Copy installer to /usr/local/bin
cp -f "${STAGING_DIR}/bin/fhawx-install" "${CHROOT_DIR}/usr/local/bin/fhawx-install"
chmod +x "${CHROOT_DIR}/usr/local/bin/fhawx-install"

# Fix ownership
chroot "${CHROOT_DIR}" chown -R fhawx:fhawx /home/fhawx

# ------------------------------------------------------------------------------
# STEP 5: Kernel & Initrd Staging + Cleanup
# ------------------------------------------------------------------------------
echo -e "${AMBER}[5/6] Extracting live kernel and packaging squashfs filesystem...${NC}"

# Find installed kernel & initrd
VMLINUZ=$(ls -t "${CHROOT_DIR}/boot/vmlinuz-"* 2>/dev/null | head -n 1)
INITRD=$(ls -t "${CHROOT_DIR}/boot/initrd.img-"* 2>/dev/null | head -n 1)

if [ -z "$VMLINUZ" ] || [ -z "$INITRD" ]; then
    echo -e "${RED}[-] Error: Kernel or Initrd not found in ${CHROOT_DIR}/boot!${NC}" >&2
    exit 1
fi

echo "  -> Kernel: $(basename "$VMLINUZ")"
echo "  -> Initrd: $(basename "$INITRD")"

cp -L "$VMLINUZ" "${ISO_DIR}/live/vmlinuz"
cp -L "$INITRD" "${ISO_DIR}/live/initrd.img"

# Clean apt cache and temp files inside chroot
chroot "${CHROOT_DIR}" apt-get clean
rm -rf "${CHROOT_DIR}/var/lib/apt/lists/"* \
       "${CHROOT_DIR}/tmp/"* \
       "${CHROOT_DIR}/var/tmp/"* \
       "${CHROOT_DIR}/etc/machine-id" \
       "${CHROOT_DIR}/var/lib/dbus/machine-id"

# Ensure machine-id is blank for unique generation per boot
touch "${CHROOT_DIR}/etc/machine-id"

# Unmount pseudo filesystems before compression
cleanup_mounts

# Build SquashFS image
echo -e "${AMBER}  -> Generating squashfs filesystem (high-ratio xz)...${NC}"
rm -f "${ISO_DIR}/live/filesystem.squashfs"
mksquashfs "${CHROOT_DIR}" "${ISO_DIR}/live/filesystem.squashfs" \
    -comp xz \
    -Xbcj x86 \
    -b 1048576 \
    -noappend

# ------------------------------------------------------------------------------
# STEP 6: Configure GRUB2 & Build Hybrid Bootable ISO
# ------------------------------------------------------------------------------
echo -e "${AMBER}[6/6] Configuring GRUB2 bootloader and authoring Hybrid ISO...${NC}"

cat << 'EOF' > "${ISO_DIR}/boot/grub/grub.cfg"
set default="0"
set timeout=5

set color_normal=light-gray/black
set color_highlight=yellow/black

menuentry "⚡ Fhawx-Deck TDE // Debian 13 (Trixie) Live [Auto-Login]" {
    linux /live/vmlinuz boot=live components quiet splash timezone=America/Chicago locales=en_US.UTF-8 username=fhawx hostname=fhawx-deck
    initrd /live/initrd.img
}

menuentry "🛠️  Fhawx-Deck TDE // Safe Graphics (nomodeset)" {
    linux /live/vmlinuz boot=live components nomodeset quiet splash timezone=America/Chicago locales=en_US.UTF-8 username=fhawx hostname=fhawx-deck
    initrd /live/initrd.img
}

menuentry "🚀 Fhawx-Deck TDE // Copy to RAM (toram)" {
    linux /live/vmlinuz boot=live components toram quiet splash timezone=America/Chicago locales=en_US.UTF-8 username=fhawx hostname=fhawx-deck
    initrd /live/initrd.img
}

menuentry "💿 Fhawx-Deck TDE // Direct Terminal Installer (fhawx-install)" {
    linux /live/vmlinuz boot=live components fhawx.install=1 quiet splash username=fhawx hostname=fhawx-deck
    initrd /live/initrd.img
}
EOF

# Ventoy / loopback config
cat << 'EOF' > "${ISO_DIR}/boot/grub/loopback.cfg"
source /boot/grub/grub.cfg
EOF

ISO_FILE="${OUTPUT_DIR}/fhawx-deck-trixie-amd64.iso"
echo "  -> Building ISO with grub-mkrescue..."
grub-mkrescue -o "${ISO_FILE}" "${ISO_DIR}" -- -volid "FHAWX_DECK" -joliet on

# Calculate SHA256
cd "${OUTPUT_DIR}"
sha256sum "$(basename "${ISO_FILE}")" > "$(basename "${ISO_FILE}").sha256"

echo -e "\n${GREEN}================================================================================${NC}"
echo -e "${GREEN}  [✓] FHAWX-DECK TDE HYBRID ISO SUCCESSFULLY GENERATED!${NC}"
echo -e "${GREEN}================================================================================${NC}"
ls -lh "${ISO_FILE}" "${ISO_FILE}.sha256"
cat "${ISO_FILE}.sha256"
