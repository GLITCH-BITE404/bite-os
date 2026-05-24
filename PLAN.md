# BITE-OS — distro build plan

Goal: turn BITE-OS from a customized CachyOS install into a real, installable
distro — a bootable/downloadable ISO + a GitHub repo. Version 1.0, codename
`dedsec`. Project lives in `~/bite-os-distro/`.

## The 5 steps

### Step 1 — Manifest  (STATUS: not started)
One document listing everything that *is* BITE-OS. Audit with:
- `pacman -Qqe` — explicitly installed packages (the set on top of CachyOS base)
- `/usr/local/bin/bite-os-*` — custom scripts (rebrand, fix-boot, fix-fastfetch)
- `/etc/pacman.d/hooks/zz-bite-os-*` — branding hooks (3)
- `/usr/share/bite-os/` — os-release, lsb-release, issue
- `~/.config/glitch/` — bin/ (rice, dots-switch, healthcheck), logos, plymouth, templates
- `~/.local/share/bite-os/` — rices vault (caelestia, ilyamiro), splash, vault-src
- Plymouth theme (`/usr/share/plymouth/themes/glitch-os`), SDDM theme (`/usr/share/sddm/themes/bite-os`)
- `/etc/sddm.conf.d/`, `~/.config/systemd/user/bite-os-healthcheck.service`
- the hypr/quickshell rice configs
Output: `~/bite-os-distro/MANIFEST.md`

### Step 2 — `bite-os` package  (STATUS: not started)
DECISION: write the PKGBUILD from scratch, BITE-OS-native — do NOT fork
CachyOS's. A branding/settings package is ~50 lines; the manifest already
inventoried every file. Reference `cachyos-hyprland-settings` for structure
only (install hooks, layout), no copying.
A PKGBUILD that installs all of the above + a dependency list. User configs
(`~/.config/hypr`, the dots, glitch dir) move into `/etc/skel` so every install
gets them. Output: `~/bite-os-distro/pkg/bite-os/PKGBUILD` + payload.
YOU run: `makepkg -si`

### Step 3 — pacman repo  (STATUS: not started, optional for v1)
`repo-add` scaffold so `[bite-os]` can be served. Output: `~/bite-os-distro/repo/`

### Step 4 — archiso ISO profile  (STATUS: not started)
Full profile: `packages.x86_64`, `profiledef.sh`, `pacman.conf`, `airootfs/`
overlay, `/etc/skel`, installer (Calamares or CachyOS installer).
Output: `~/bite-os-distro/iso/`
YOU run: `sudo mkarchiso -v -w /tmp/bitework -o ~/bite-os-distro/out ~/bite-os-distro/iso`
(needs `archiso` package installed, root, ~20+ min, several GB disk)

### Step 5 — Version + GitHub  (STATUS: not started)
Set version 1.0 (not `rolling`), codename dedsec. `git init` the project,
README, .gitignore. YOU run: create GitHub repo + `git push`; upload the ISO
as a Release asset.

## Resume instructions for next session
Start at Step 1. Run the audit, write MANIFEST.md, then proceed 2→5.
All BITE-OS components are catalogued above. Bootloader = systemd-boot, ESP
at /boot — NEVER touch boot paths (see memory: project-branding-hooks).

## Already done (today's session, 2026-05-17)
- ilyamiro rice: all bugs fixed, 73 keybinds, weather on Open-Meteo, riced,
  saved to vault. See memory: project-ilyamiro-keybinds, project-rice-persistence.
- Branding hooks renamed `99-` → `zz-` so they win over CachyOS.
- Hardened `bite-os-fix-boot` (title-only, boot-safe). Boot titles = "BITE-OS".
- First-boot healthcheck service + guide-on-first-boot.
- Backups in `~/bite-os-fixes-backup/`.
