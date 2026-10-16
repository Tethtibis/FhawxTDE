# FHAWXTDE // Terminal Desktop Environment

<p align="center">
  <img src="assets/fhawx_emblem.jpg" width="280" alt="FhawxTDE Trinity Seal" />
</p>

<p align="center">
  <b>A distraction-free, keyboard-and-mouse monochromatic Burnt Orange (<code>#CC5500</code>) Terminal Desktop Environment.</b><br />
  <i>Run it on-demand in any terminal or SSH window like <code>dosshell</code>, or boot directly into it on retro netbooks.</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-orange.svg" alt="License: MIT" />
  <img src="https://img.shields.io/badge/Target-Debian%2012%2F13%20|%20Ubuntu%20|%20Mint%20|%20SSH-FF5500.svg" alt="Base OS" />
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

**FhawxTDE** is a unified, dual-workspace **Terminal Desktop Environment** styled in a monochromatic Amber / Burnt Orange (`#CC5500`) CRT aesthetic.

Inspired by classic on-demand environments like **MS-DOS Shell (`dosshell`)** and **Midnight Commander**, FhawxTDE does **not** hijack your operating system or overwrite your personal desktop by default. You keep your normal Linux command line and desktop environment, and simply type **`fhawx`** (or **`tde`**) inside *any* local terminal window or remote **SSH session** whenever you want to enter the cockpit.

* **Works Over SSH with Full Mouse Support:** Click `[⚡ APPS (Alt+A)]`, click panes to focus, and drag borders to resize—even over a headless SSH connection with zero X11 server installed.
* **Isolated Socket Architecture:** Runs on its own dedicated socket (`tmux -L fhawx`) so it never collides with your existing `~/.tmux.conf` or standard `tmux` sessions.
* **Unified Command Palette (`Alt+A` / `Alt+Space`):** Launch notes, network tools, SSH stations, and system telemetry instantly.
* **Dual-Workspace Architecture (`Alt+W`):** Indestructible 2-workspace navigation with auto-resurrection.
* **Intelligent Auto-Splitting (`Alt+S`):** Seamless toggle between single-focus fullscreen and dual-screen split view.
* **Optional Netbook Kiosk Mode (`--kiosk`):** Want to turn a vintage 1GB–2GB RAM netbook (Dell Inspiron 1012, Eee PC, Chromebook) into a dedicated sub-250MB RAM machine? Pass `--kiosk` to boot straight into FhawxTDE on `/dev/tty1`.

---

## 🚀 Quick Install (Debian / Ubuntu / Linux Mint / Raspberry Pi OS)

### 1. Default Install: On-Demand CLI & SSH Mode ("DOS Shell" Mode)
Installs only the lightweight terminal tools and the `fhawx` / `tde` command. Does **not** install Xorg or alter your desktop login:

```bash
curl -fsSL https://raw.githubusercontent.com/Tethtibis/FhawxTDE/main/install.sh | bash
```

Once installed, launch or exit anytime from any terminal or SSH window:
```bash
fhawx          # Enter FhawxTDE (or use shorthand: tde)
fhawx status   # Check if your FhawxTDE session is running in the background
fhawx stop     # Shut down the background FhawxTDE session completely
```

### 2. Optional: Dedicated Netbook Kiosk Mode (`--kiosk`)
For vintage netbooks or dedicated appliances where you want FhawxTDE to act as the full-screen primary desktop environment on boot (includes Micro-X11 for bare-metal trackpad tap-to-click):

```bash
curl -fsSL https://raw.githubusercontent.com/Tethtibis/FhawxTDE/main/install.sh | bash -s -- --kiosk
```

*(Or from a local clone: `sudo ./install.sh --kiosk`)*

---

## ⌨️ Pure-Alt Keybinding Cheatsheet

All core desktop operations are bound to simple, single-modifier **Alt + Key** mnemonics:

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| **`Alt + A`** or **`Alt + Space`** | **App Launcher** | Opens the centralized FhawxTDE command palette |
| **`Alt + W`** | **Toggle Workspace** | Smoothly switches between **Workspace 1** and **Workspace 2** |
| **`Alt + S`** | **Toggle Split Screen** | Toggles between Fullscreen Single-Pane and Side-by-Side Dual-Pane |
| **`Alt + K`** | **Kill Active Pane** | Defensive termination modal (`Enter` cancels, arrow down to confirm) |
| **`Alt + O`** or **`Alt + Tab`** | **Cycle Active Pane** | Focuses the adjacent pane (SSH / KVM / RustDesk friendly) |
| **`Alt + Z`** | **Zoom Pane** | Temporarily maximizes the active pane to 100% width |
| **`Alt + Q`** | **Minimize to Shell** | Detaches FhawxTDE and returns to your normal command prompt (`fhawx` to resume) |
| **Mouse Click** | **Click to Focus** | Click `[⚡ APPS (Alt+A)]` or any pane to focus (works locally and over SSH) |

---

## 🧰 Built-in App Stations

### 1. ✍️ Daily Writer Note (`micro`)
* Built-in distraction-free writing environment saving directly to `~/Documents/Daily_Note.md`.
* Embedded shortcut hints at the top of every note (`[Ctrl+S]` Save, `[Ctrl+Q]` Quit).

### 2. ⚡ SSH Station (`fhawx-ssh`)
* Amber phosphor CRT terminal connection manager.
* Runs directly inside your active pane and returns gracefully on exit.
* Built-in inline configuration editor (`e` to edit, `a` to add, `d` to delete) with full line editing and password masking.

### 3. 📶 Wi-Fi Manager (`fhawx-wifi`)
* Interactive terminal scanner for 2.4GHz / 5GHz wireless networks via NetworkManager.

### 4. 🛡️ WireGuard VPN Tunnel (`fhawx-vpn`)
* Rapid toggling and profile switching for WireGuard tunnels stored in `~/wireguard/`.

### 5. 📊 Real-Time Status Bar & Fastfetch
* Embedded top status bar showing live CPU% delta sampling (`/proc/stat`), active network link (`[ETH]`, `[Wi-Fi]`, `[NET:OFF]`), VPN state, audio volume, and battery/AC telemetry.
* Custom Fastfetch configuration featuring the **Fhawx Trinity Glyph** rendered in a 76×68 Unicode micro-dot matrix.

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
Designed and maintained by **Bill Fullen ([@Tethtibis](https://github.com/Tethtibis))**.
