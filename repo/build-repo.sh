#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  ◈ BITE-OS — build the local [bite-os] pacman repo
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# mkarchiso can only install packages that live in a repo. This collects the
# `bite-os` package + the foreign (AUR) packages the rice needs into a local
# repo at repo/x86_64/.
#
# For each foreign package it: checks the pacman cache → checks paru's cache →
# builds it with paru if still missing. Failures are per-package (one bad one
# doesn't abort the rest), so you see exactly what needs hand-attention.
#
# Run as your normal user (NOT root):  bash build-repo.sh
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$HERE/x86_64"
DISTRO="$(cd "$HERE/.." && pwd)"
CACHES=(/var/cache/pacman/pkg "$HOME/.cache/paru/clone")
mkdir -p "$REPO"

# newest .pkg.tar.* for a package name, searched across all caches
find_pkg() {
    local name="$1" hit=""
    for c in "${CACHES[@]}"; do
        hit="$(find "$c" -maxdepth 2 -name "${name}-*.pkg.tar.*" ! -name '*.sig' 2>/dev/null \
               | sort -V | tail -1)"
        [ -n "$hit" ] && { echo "$hit"; return 0; }
    done
    return 1
}

echo "==> 1/4  Building the bite-os package (fresh)"
( cd "$DISTRO/pkg/bite-os" && makepkg -f --noconfirm ) || {
    echo "!! makepkg failed — fix PKGBUILD/payload, then re-run." >&2; exit 1; }
cp "$DISTRO/pkg/bite-os/"bite-os-*.pkg.tar.* "$REPO/" 2>/dev/null

echo "==> 2/4  Building yaml-cpp-0.8 compat (calamares needs libyaml-cpp.so.0.8)"
# Reuse existing build if PKGBUILD hasn't changed (saves ~30s per ISO rebuild).
EXISTING_YAML="$(find "$REPO" -maxdepth 1 -name 'yaml-cpp-0.8-*.pkg.tar.*' ! -name '*.sig' | head -1)"
if [ -n "$EXISTING_YAML" ] && [ "$EXISTING_YAML" -nt "$DISTRO/pkg/yaml-cpp-0.8/PKGBUILD" ]; then
    echo "   cached  yaml-cpp-0.8"
else
    ( cd "$DISTRO/pkg/yaml-cpp-0.8" && makepkg -f --noconfirm ) || {
        echo "!! yaml-cpp-0.8 makepkg failed — calamares won't start without it." >&2; exit 1; }
    cp "$DISTRO/pkg/yaml-cpp-0.8/"yaml-cpp-0.8-*.pkg.tar.* "$REPO/" 2>/dev/null
fi

echo "==> 3/4  Collecting foreign packages"
missing=()
while read -r p; do
    [ -z "$p" ] && continue
    if f="$(find_pkg "$p")"; then
        cp "$f" "$REPO/"; echo "   ok    $p"
        continue
    fi
    echo "   build $p  (not cached — building with paru)"
    paru -S --rebuild --noconfirm --skipreview "$p" >/dev/null 2>&1
    if f="$(find_pkg "$p")"; then
        cp "$f" "$REPO/"; echo "   ok    $p  (built)"
    else
        missing+=("$p"); echo "   FAIL  $p"
    fi
done < "$HERE/foreign-packages.txt"

echo "==> 4/4  Indexing the repo"
repo-add -q "$REPO/bite-os.db.tar.gz" "$REPO/"*.pkg.tar.* 2>/dev/null

echo
echo "Local repo: $REPO  ($(find "$REPO" -name '*.pkg.tar.*' ! -name '*.sig' | wc -l) packages)"
if [ ${#missing[@]} -gt 0 ]; then
    echo "!! Could not get: ${missing[*]}"
    echo "   These aren't on the AUR. Get their source and 'makepkg' them, or"
    echo "   drop them from iso/packages.x86_64. Then re-run."
    exit 1
fi
echo "✓ All packages collected. Next: sudo bash build-iso.sh"
