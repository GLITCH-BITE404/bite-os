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

<div align="center">

*More tools live in [`src/`](src/) — readable, no build step.*

`BITE-OS` · hand-built by **GLITCH-BITE404** · 🐕 [Laffy](LAFFY.md)

</div>
