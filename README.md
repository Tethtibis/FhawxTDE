# FHAWXTDE // Terminal Desktop Environment

<p align="center">
  <img src="assets/fhawx_emblem.jpg" width="280" alt="FhawxTDE Trinity Seal" />
</p>

<p align="center">
  <b>A distraction-free, keyboard-driven monochromatic Burnt Orange (<code>#CC5500</code>) Terminal Desktop Environment.</b><br />
  <i>Engineered for retro netbooks (Dell Inspiron, Eee PC, Intel Atom), low-spec Chromebooks, VMs, and distraction-free server consoles.</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-orange.svg" alt="License: MIT" />
  <img src="https://img.shields.io/badge/Target-Debian%2012%2F13%20|%20Ubuntu%20|%20Mint-FF5500.svg" alt="Base OS" />
  <img src="https://img.shields.io/badge/Aesthetic-Burnt%20Orange%20CRT-CC5500.svg" alt="Aesthetic" />
</p>

---

```text
          ⢀⣠⣴⡶⣫⣴⣶⣿⣿⠿⢿⣶⣦⣝⢶⣦⣄⡀          
        ⣠⣶⢟⡫⡙⢰⣿⠿⠯⡡⠶⢒⢉⣻⣿⣿⡆⢋⢝⡻⣶⣄        
      ⢠⣾⢋⣵⠿⣫⣡⠸⣿⣴⣦⡞⠑⠲⡃⡘⣿⣿⠇⣬⣝⠿⣮⡙⣷⡄      
     ⣰⠄⣁⠛⠣⣾⢫⡶⣓⣌⢙⡿⢄⢀⡀⡱⢿⡋⣡⣚⢶⡝⣷⠜⠛⣈⣤⣆     
    ⢰⡏⣼⣿⣿⣶⣤⣙⠱⢿⣾⣿⣦⣠⠏⠹⣄⣴⣿⣷⡿⠎⣋⣤⣶⣿⠟⢻⣿⣆    
    ⣿⢸⣿⣿⣿⣿⣿⣿⣿⣶⣬⣙⠻⢃⣾⣷⡘⠟⢋⣥⣶⣿⣿⡟⠹⠁ ⢿⣿⣿    
    ⡟⢫⣾⣿⣿⣿⣿⣿⡿⠟⠛⠋⢡⡿⠁⠈⢿⡌⢿⣇⡮⡻⣿⣷ ⣠⢶ ⠏⢿    
    ⣌⠢⠭⠍⡟⠉⠙⠋⠑⣶⣆⣐⣛⡛⡛⢛⣛⣛⣂⡙⡇⣹⣾⣷⣾⡏⢸ ⢀⣿    
    ⠸⣟⣋⣉⢨⡐  ⣊⠈⣿⣭⡉ ⡇⢸⣿⣿⣿⢟⣿⡿⢿⣿⡿⢿⣧⡰⣿⠏    
     ⠹⣿⣿⣄⢸ ⢸⢁⠼    ⡇⢸⡿⠃⠛⣠⣯⣟⣿⣿⣿⠛⡽⣺⠏     
      ⠙⢿⣿⣋⡈⢈⣻⡒⠒⡄⡠⠖⡇⢸⠁ ⡄⠸⠟⠛⠘⠛⠃⢀⡴⠋      
        ⠙⠿⣿⣿⣿⣿⣇⠘⡅ ⡇⢸⣇⢷⣿⣷⡸⣿⣶⣶⠿⠋        
          ⠈⠙⠻⢿⣿⣦⣌⡂⡇⢸⣿⣷⣾⣭⡽⠞⠋⠁          
               ⠈⠉⠉⠁⠈⠉⠉⠁               
```

## ⚡ What is FhawxTDE?

Modern desktop environments (GNOME, KDE, Windows) are heavy, noisy, and constantly consume 1.5GB to 4GB of RAM idling in the background. Vintage netbooks (such as the Dell Inspiron 1012, Eee PC, Intel Atom N450 machines with 1GB–2GB RAM) and converted Chromebooks choke on modern GUIs.

**FhawxTDE** strips away all desktop bloat and replaces it with a clean, unified, full-screen **Terminal Desktop Environment**:
* **Sub-250MB RAM Footprint:** Complete system idles under 250MB RAM.
* **Unified Command Palette (`Alt+A` / `Alt+Space`):** Launch notes, network tools, SSH stations, and system telemetry instantly.
* **Dual-Workspace Architecture:** Indestructible dual-workspace navigation with auto-resurrection (`Alt+W`).
* **Intelligent Auto-Splitting (`Alt+S`):** Seamless toggle between single-focus fullscreen and dual-screen split view with automatic right-pane focus.
* **Pure Amber / Burnt Orange CRT Aesthetic:** Designed for long hours of writing, programming, and server administration without eyestrain.

---

## 🚀 Quick Install (Any Debian / Ubuntu / Mint / Chromebook)

If you already have a stock Debian 12/13, Ubuntu, Linux Mint, or Raspberry Pi OS installation, deploy FhawxTDE with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/Tethtibis/FhawxTDE/main/install.sh | bash
```

Alternatively, clone the repository locally:

```bash
git clone https://github.com/Tethtibis/FhawxTDE.git
cd FhawxTDE
sudo ./install.sh
```

---

## ⌨️ Pure-Alt Keybinding Cheatsheet

All core desktop operations are bound to simple, single-modifier **Alt + Key** mnemonics:

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| **`Alt + A`** or **`Alt + Space`** | **App Launcher** | Opens the centralized FhawxTDE command palette |
| **`Alt + W`** | **Toggle Workspace** | Smoothly switches between **Workspace 1** and **Workspace 2** |
| **`Alt + S`** | **Toggle Split Screen** | Toggles between Fullscreen Single-Pane and Side-by-Side Dual-Pane |
| **`Alt + K`** | **Kill Active Pane** | Defensive termination modal (`Enter` cancels, arrow left/right to confirm) |
| **`Alt + O`** | **Cycle Active Pane** | Focuses the adjacent pane (remote KVM / VNC / RustDesk safe) |
| **Mouse Click** | **Click to Focus** | Full mouse support enabled; click anywhere in a pane to switch focus |

---

## 🧰 Built-in App Stations

### 1. ✍️ Daily Writer Note (`micro`)
* Built-in distraction-free writing environment saving directly to `~/Documents/Daily_Note.md`.
* Embedded shortcut hints at the top of every note:
  * `[Ctrl + S]` — Quick Save
  * `[Ctrl + Q]` — Graceful Exit
  * `[Ctrl + E]` + `quit` — Command-line exit

### 2. ⚡ SSH Station (`fhawx-ssh`)
* Amber phosphor CRT terminal connection manager.
* Zero quad-pane bloat: runs directly inside your active pane and returns gracefully on exit.
* Built-in inline configuration editor (`e` to edit, `a` to add, `d` to delete) with full line editing and password masking.

### 3. 📶 Wi-Fi Manager (`fhawx-wifi`)
* Interactive terminal scanner for 2.4GHz / 5GHz wireless networks.
* Connects seamlessly via NetworkManager without requiring desktop applets.

### 4. 🛡️ WireGuard VPN Tunnel (`fhawx-vpn`)
* Rapid toggling and profile switching for WireGuard tunnels stored in `~/wireguard/`.

### 5. 📊 Real-Time Status Bar & Fastfetch
* Embedded top status bar showing live CPU% delta sampling (`/proc/stat`), active network link (`[ETH]`, `[Wi-Fi]`, `[NET:OFF]`), VPN state, and battery telemetry.
* Custom Fastfetch configuration featuring the high-definition **Fhawx Trinity Glyph** rendered in 76×68 Unicode micro-dot matrix.

---

## 💻 Hardware Targets

* **Vintage Netbooks:** Dell Inspiron Mini 10/1012, Asus Eee PC, Acer Aspire One (Intel Atom N450 / 1GB–2GB RAM).
* **Converted Chromebooks:** Devices running MrChromebox UEFI firmware or native Linux chroots.
* **Virtual Machines:** KVM / QEMU, Proxmox VE, VirtualBox, VMware.
* **Headless Servers & Single-Board Computers:** Perfect interface over persistent SSH / ttyd sessions.

---

## 💿 Universal Live ISO

A bootable hybrid Live/Installer ISO based on Debian 13 (Trixie) amd64 is buildable using the included builder script:

```bash
sudo ./build_iso.sh
```

The resulting ISO supports UEFI and Legacy BIOS booting, Ventoy USBs, and direct bare-metal installation (`fhawx-install`).

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
Designed and maintained by **Bill Fullen ([@Tethtibis](https://github.com/Tethtibis))**.
