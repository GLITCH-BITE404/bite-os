#!/usr/bin/env bash
# ━━━ BITE-OS — archiso build-time customisation ━━━
# Runs inside the airootfs chroot once, after pacstrap has installed every
# package. We use this hook to create the live `bite` user and populate its
# home from /etc/skel HERE, at build time — single-threaded, no SDDM racing
# us, /etc/skel is guaranteed-complete because pacstrap already finished.
#
# Why not do this at boot in bite-os-live-setup? Because at boot the skel
# copy has raced with SDDM autologin multiple times, leaving an incomplete
# /home/bite/ → Hyprland falls back to its rescue config. Doing it here
# bakes a correct home directly into the squashfs.
set -uo pipefail
echo "[customize_airootfs] start"

# 1. User + groups + passwords
if ! id bite &>/dev/null; then
    useradd -m -u 1000 -G wheel,video,audio,network,storage,input,lp -s /bin/bash bite
fi
echo 'bite:bite' | chpasswd
echo 'root:bite' | chpasswd

# 2. Force-sync /etc/skel into /home/bite — useradd already did this, but
#    re-run idempotently in case any postinst hooks updated skel after the
#    initial copy.
if [ -d /etc/skel ]; then
    cp -an /etc/skel/. /home/bite/ 2>/dev/null || true
fi
chown -R bite:bite /home/bite

# 3. Passwordless sudo for the live session ONLY. Calamares wipes
#    /etc/sudoers.d/ when configuring the installed system, so this file
#    doesn't leak into the install.
install -d -m 0750 /etc/sudoers.d
cat > /etc/sudoers.d/00-bite-live <<'EOF'
bite ALL=(ALL) NOPASSWD: ALL
EOF
chmod 440 /etc/sudoers.d/00-bite-live

# 4. Auto-start the installer in the live session only — this .desktop goes
#    into the live user's home, not /etc/skel, so installed users never
#    autostart the installer.
if [ -f /usr/share/applications/install-bite-os.desktop ]; then
    install -d -o bite -g bite /home/bite/.config/autostart
    cp /usr/share/applications/install-bite-os.desktop \
       /home/bite/.config/autostart/
    chown bite:bite /home/bite/.config/autostart/install-bite-os.desktop
fi

# 5. Sanity check — fail the build loudly if the critical config didn't land.
if [ ! -s /home/bite/.config/hypr/hyprland.conf ]; then
    echo "[customize_airootfs] FATAL: /home/bite/.config/hypr/hyprland.conf missing or empty after skel copy" >&2
    echo "[customize_airootfs] /etc/skel contents:" >&2
    ls -la /etc/skel/.config/hypr/ 2>&1 >&2 || true
    exit 1
fi

echo "[customize_airootfs] done. /home/bite populated, $(find /home/bite -type f | wc -l) files."
