#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  ◈ BITE-OS — one-time signing-key setup for the update repo
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Creates the GPG key that signs your rice packages, and exports the PUBLIC key
# so it can be baked into the OS (installed systems trust it → nobody can push
# fake "BITE-OS" updates). Run this ONCE.  Your PRIVATE key stays in ~/.gnupg
# and must be kept safe — it's what proves updates are really from you.
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
DISTRO="$(cd "$HERE/.." && pwd)"
NAME="BITE-OS Repo Signing Key"
EMAIL="virnikrephael@gmail.com"
PUB_REPO="$HERE/bite-os-repo.pub"
PUB_OS="$DISTRO/iso/airootfs/usr/share/bite-os/bite-os-repo.pub"

if gpg --list-keys "$NAME" >/dev/null 2>&1; then
    echo "Signing key already exists: $NAME"
else
    echo "==> Generating a 4096-bit signing key (no passphrase, so publishing is one command)..."
    gpg --batch --gen-key <<EOF
%no-protection
Key-Type: rsa
Key-Length: 4096
Key-Usage: sign
Name-Real: $NAME
Name-Email: $EMAIL
Expire-Date: 0
%commit
EOF
fi

KEYID="$(gpg --list-keys --with-colons "$NAME" | awk -F: '/^pub/{print $5; exit}')"
mkdir -p "$(dirname "$PUB_OS")"
gpg --export --armor "$KEYID" | tee "$PUB_REPO" > "$PUB_OS"

echo
echo "✓ Signing key ready."
echo "  Key ID:      $KEYID"
echo "  Public key:  $PUB_REPO"
echo "               $PUB_OS  (gets baked into the next ISO)"
echo
echo "Next steps:"
echo "  1. bash repo/publish-repo.sh        # build, sign, upload your rice"
echo "  2. sudo bash build-iso.sh           # rebuild ISO so it trusts + checks the repo"
echo "  ⚠  Publish (step 1) BEFORE distributing the new ISO, or installed systems"
echo "     will try to reach a repo that isn't there yet."
