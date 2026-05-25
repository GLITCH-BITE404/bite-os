<div align="center">

# 🛠 Built by hand

### The engineering behind BITE-OS · `// THE SYSTEM BIT YOU`

</div>

BITE-OS isn't a theme dropped on top of a distro. The pieces below were **written
from scratch** for it — the stuff that makes it behave like its own system, not a
wallpaper. This page is the workshop tour.

---

## `glitch-fetch` — the gacha fetch engine

A complete **fastfetch rewrite** in pure Bash. What it does that stock fetch tools don't:

- **Gacha logo roll** — every time you open a terminal it picks a **random** logo from
  your icon pool (Laffy, the BITE fangs, glitch art). No two terminals look the same.
- **Aspect-aware layouts** — it classifies each image (by `sq_` / `wd_` / `tl_` filename
  prefix) and renders it into a **matching template**: centered, side-by-side, or
  vertical — so a tall image and a wide image both look *designed*, not stretched.
- **Resize-aware rendering** — it reads the live terminal size (`tput cols`/`lines`) and
  **scales the logo + the framed text box uniformly to fit** the current window. The
  sixel image never gets squished on a short or narrow terminal, and the boxed
  system-info readout stays aligned at any size.
- **Stable on resize** — the rolled pick is **cached per shell session**, so resizing
  a window redraws at the new size *without* re-rolling the gacha. Each session keeps
  its logo; only a fresh shell rolls again.
- **Framed readout** — distro / kernel / cpu+temp / gpu+usage / mem / shell / uptime /
  pkgs, drawn in a glyph-bordered box with the accent colour keyed to the theme.

> The result: opening a terminal feels like the system *greeting* you — a different
> face every time, always fitted to the window.

---

## `rice` — the rice vault

Your whole desktop as a **versioned, swappable artifact** instead of fragile dotfiles:

- `rice save <name>` — snapshots every managed config dir into a named vault entry.
- `rice load <name>` — swaps to it, **auto-backing-up the current state first**.
- `rice rollback` — undo the last load, instantly.
- Destructive ops move files aside (never delete); anything outside the managed set is
  never touched.

---

## Dot-switch + watchdog

Two **complete** desktops (`caelestia` + `ilyamiro`), swapped with **one keypress**.
Every swap auto-backs-up, and a **30-second watchdog auto-reverts** if the new desktop
fails to come up — so you **physically cannot lock yourself out.**

---

## `bite-os-update` — one-key updater (`SUPER+U`)

A full system update (kernel / apps / AUR / rice) that **re-asserts BITE-OS branding on
every run**, so updates never decay it back into vanilla CachyOS. It's **optional**
(checks first, only acts if there's something to do), **asks before touching anything**,
and **logs** every run. Pulls BITE-OS itself from the project's own pacman repo.

---

## Self-heal

A login **healthcheck** quietly detects and rebuilds a wiped or broken config. Combined
with the vault + watchdog, the system is built to recover from the exact kind of mess
that started this project (see [Laffy](LAFFY.md) — it began with a brick).

---

## Glitch mode (`SUPER+B`)

A **LARP overlay** that engages a glitch shader, a dedsec video wallpaper, an amber
"trace" HUD and paced popups — then **tears all of it down cleanly**, restoring your
exact previous state (shader, damage tracking, borders, wallpaper). It's effects as a
toggle, not a permanent cost.

---

## Wallpaper engine

- **VAAPI video wallpapers** that hardware-decode instead of pinning the CPU.
- An **auto-pause daemon** that freezes the wallpaper while a window is fullscreen.
- A **ghost-reaper** that guarantees exactly one wallpaper process — no stacked
  duplicates eating CPU, no matter how fast you switch.
- **`wall-optimize`** — down-rates any wallpaper video to a lower frame rate for lower
  idle CPU, backing up the original.

---

## Background system (caelestia rewrite)

Stock caelestia does **image** wallpapers (swww). I **rewrote the background subsystem**
so it does **live video** too:

- A unified setter routes **images → hyprpaper** and **videos → mpvpaper**, transparently.
- The shell's background surface **detects a video source and goes transparent** so
  mpvpaper shows through underneath — the bar/widgets still composite on top.
- For videos, it grabs a **still frame and feeds it to matugen**, so the whole
  Material-You colour scheme themes itself off your *video* wallpaper, not just images.
- State is tracked so the picker shows the right checkmark and the wallpaper **restores
  on reboot**.

---

## Power modes (`glitch-power`)

A from-scratch **power-profile switcher** — `saver` / `balanced` / `perf` — that I built
to coordinate layers that normally don't know about each other, all from one toggle:

- **CPU:** flips Intel turbo boost, sets the **cpupower governor** (powersave /
  performance / schedutil) and frequency caps.
- **System:** sets the **power-profiles-daemon** profile to match.
- **Compositor:** toggles Hyprland-side effects for the mode.
- **Shell:** patches caelestia's `shell.json` so the bar/drawer's **own animations and
  transparency react too** — and does it with an **atomic write** (temp file on the same
  filesystem + rename) so Quickshell's config-watcher can't catch a half-written JSON and
  glitch the bar mid-switch.
- Root knobs are wrapped in `sudo -n`, so a missing sudoers rule just no-ops instead of
  prompting or breaking.

> One tap = CPU, daemon, compositor *and* the shell's look all shift together, cleanly.

---

<div align="center">

*More tools live in [`src/`](src/) — readable, no build step.*

`BITE-OS` · hand-built by **GLITCH-BITE404** · 🐕 [Laffy](LAFFY.md)

</div>
