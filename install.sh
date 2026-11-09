#!/bin/sh
# First-run setup, run by `fili-bar install` / `fili-bar setup` / `fili-bar sync`. Idempotent; asks questions only on a terminal.
# Secrets never go in this folder: they go to the keyring or to a file under ~/.config.
set -u
here="$(cd "$(dirname "$0")" && pwd)"
opts="${FILI_BAR_OPTIONS:-$HOME/.config/filigrane/bar/icloud.toml}"
tty=0; [ -t 0 ] && tty=1
# Options file: copy the example once, never overwrite
if [ ! -e "$opts" ] && [ -f "$here/config.example.toml" ]; then
    mkdir -p "$(dirname "$opts")" && cp "$here/config.example.toml" "$opts" && echo "options: $opts (edit it to change the defaults)"
fi
command -v rclone >/dev/null 2>&1 || { echo "rclone is required (sudo xbps-install rclone)" >&2; exit 1; }
. "$here/bin/opt.sh"
remote="$(opt remote icloud:)"
if ! rclone listremotes 2>/dev/null | grep -qx "$remote"; then
    if [ "$tty" = 1 ]; then
        echo "Create the rclone remote ${remote%:} (type iclouddrive; Apple ID, password, 2FA code)."
        rclone config
    else
        echo "create the remote: rclone config (name ${remote%:}, type iclouddrive)"
    fi
fi
