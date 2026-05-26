#!/usr/bin/env bash
# BITE-OS post-login splash. Runs once per Hyprland session, then exits.
set -u

HERE="$(dirname "$(readlink -f "$0")")"
URL="file://$HERE/index.html"
PROFILE="$(mktemp -d -t bite-splash-XXXXXX)"
DURATION="${BITE_SPLASH_DURATION:-7}"

cleanup() {
  pkill -f "user-data-dir=$PROFILE" 2>/dev/null || true
  rm -rf "$PROFILE"
}
trap cleanup EXIT

google-chrome-stable \
  --user-data-dir="$PROFILE" \
  --class=bite-splash \
  --app="$URL" \
  --kiosk \
  --start-fullscreen \
  --no-first-run \
  --noerrdialogs \
  --disable-translate \
  --disable-features=TranslateUI \
  --disable-session-crashed-bubble \
  --hide-scrollbars \
  --window-size=1920,1080 \
  >/dev/null 2>&1 &

CHROME_PID=$!
sleep "$DURATION"
kill "$CHROME_PID" 2>/dev/null || true
