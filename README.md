<div align="center">

# ▟▛▜▙ BITE-OS

### `// THE SYSTEM BIT YOU`

<img src="logo-hero.jpg" alt="BITE-OS Logo" width="400"/>

**A glitch-themed, performance-obsessed Linux distribution.**
Built on the CachyOS base — riced to the teeth, engineered to never get in your way.

`v1.0` · codename **dedsec** · by **GLITCH-BITE404**

[![TikTok](https://img.shields.io/badge/TikTok-@glitch__bite404-ff0050?style=for-the-badge&logo=tiktok)](https://www.tiktok.com/@glitch_bite404)
![Base](https://img.shields.io/badge/base-CachyOS%20%2F%20Arch-1793d1?style=for-the-badge&logo=archlinux)
![Shell](https://img.shields.io/badge/desktop-Hyprland%20%2B%20Quickshell-00ff78?style=for-the-badge)
[![License](https://img.shields.io/badge/license-GPLv3-cba6f7?style=for-the-badge)](LICENSE)

</div>

---

## ◈ What makes it BITE

BITE-OS isn't a reskin. It ships things stock Arch and CachyOS simply don't have:

> ⚠️ **Developer Note:** Unlike basic rice builds, most of the system UI has been completely reprogrammed, optimized, and natively pre-riced from the ground up for zero-latency execution.

- **🦷 Dot-switch** — two *complete* desktops (`caelestia` + `ilyamiro`), swapped with **one keypress**. Every swap auto-backs-up your config, and a 30-second watchdog auto-reverts if anything breaks. You physically cannot get locked out.
- **⚙ Live GUI settings** — keybinds, language, weather, startup apps and dot-switching — all editable from an in-system panel. No text files. Configs recompile and reload instantly.
- **🛠 Self-repair** — a health check runs at every login and rebuilds a wiped config automatically. The OS fixes itself.
- **⚡ Fast** — a full heavy glitch/DEDSEC rice that idles around **5% CPU** and holds **144 fps**. Performance is the whole point.
- **🌐 Keyless weather, glitch borders, animated everything** — and it still doesn't lag.

---

## ◈ Custom Keybinds Matrix

The system maps directly to these custom core inputs for elite navigation:

| Keybinding | Action | Execution Target |
|---|---|---|
| `SUPER + B` | **Hacker Aesthetic Overlay** | Triggers the "LARP" mode for full system cyber visual effects |
| `SUPER + T` | **Open Terminal** | Launches the pre-configured terminal environment instantly |
| `SUPER + Q` | **Close Window** | Safely terminates the active focused window |
| `SUPER + ALT + SPACE` | **Toggle Floating Mode** | Forces the active window into a floating layer |
| `SUPER + BACKSPACE` | **Hot-Swap to Ilyamiro** | Executes a rapid swap directly to the `ilyamiro` dots profile |
| `CTRL + SUPER + D` | **Hot-Swap to Caelestia** | Executes a rapid swap straight back to the `caelestia` dots profile |
| `SUPER + R` | **Reload Waybar** | Instantly recompiles and hot-reloads the Waybar panel |

---

## ◈ Download

> The ISO (~5 GB) is hosted off-GitHub due to file-size limits.

**➡ [Download BITE-OS 1.0 (dedsec)](https://archive.org/download/bite-os-1.0-x86_64_20260520/bite-os-1.0-x86_64.iso)**

`SHA256`: `64f67306b6e848baacf7a4feb20062b74ea8faa238e5aca87c276521f2bda052`

## ◈ Install

1. Flash the ISO to a USB (≥ 8 GB) with [Impression](https://apps.gnome.org/Impression/), [Ventoy](https://www.ventoy.net/), or `dd`.
2. Boot it. BITE-OS comes up as a **live environment** and logs you straight into the desktop. (If a login screen ever appears: user **`bite`**, password **`bite`**.)
3. Open **Install BITE-OS** (the graphical installer) — click through it: language → disk → *your* username + password → install.
4. Reboot into your own riced BITE-OS.

No terminal required.

## ◈ Source

The core engineered logic — dot-switch + watchdog, self-repair, the live
settings engine, the rice vault — lives in **[`src/`](src/)**, readable and
auditable with no build step. See [`src/README.md`](src/README.md) for the map.

## ◈ Build it yourself

BITE-OS is assembled from this repo on an Arch / CachyOS host:

```bash
bash repo/build-repo.sh        # build the bite-os package + local repo
sudo pacman -S --needed archiso
sudo bash build-iso.sh         # build the ISO -> out/
```

> **Note:** the `bite-os` package payload (the rices, themes and tooling) is
> staged from a running BITE-OS system and is not committed here to keep the
> repo lean. The shipped ISO above is the ready-to-use build.

## ◈ License & Credit

BITE-OS is © 2026 **GLITCH-BITE404** and released under the **GNU General Public
License v3.0** ([`LICENSE`](LICENSE)). In short: you're free to use, study, share
and modify it — but **if you copy, fork, remix or redistribute BITE-OS you must
credit the author (GLITCH-BITE404), link back to this repo, keep your version
open-source under the same license, and not pass your fork off as the official
BITE-OS.** Full terms and the attribution requirements are in [`NOTICE`](NOTICE).

The bundled upstream packages (Hyprland, CachyOS base, Calamares, caelestia,
fonts, …) keep their own respective licenses.

---

<div align="center">

`// THE SYSTEM BIT YOU` — built by **GLITCH-BITE404**

</div>
