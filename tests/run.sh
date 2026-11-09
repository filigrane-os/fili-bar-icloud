#!/bin/sh
# Tests of the icloud plugin: no network and no real account (the external commands are stubs). Usage: tests/run.sh
PLUGIN=icloud
. "$(dirname "$0")/common.sh"

stub rclone 'case "$1" in listremotes) echo "icloud:" ;; esac'
common_checks
# the module is shown only while the drive is not mounted
printf 'mountpoint = "~/drive"\n' > "$T/options.toml"
stub mountpoint 'echo "$*" >> "$LOG"; exit 0'
check "icloud-state is hidden while mounted" '[ "$(in_env "$ROOT/bin/icloud-state")" = "{\"text\": \"\"}" ]'
check "icloud-state asks about the mountpoint of the options file" 'grep -q "$HOME_T/drive" "$LOG"'
stub mountpoint 'exit 1'
check "icloud-state shows a warning while not mounted" 'in_env "$ROOT/bin/icloud-state" | grep -q "\"class\": \"off\""'
rm -f "$T/options.toml"
# the Apple session reminder: nothing before 25 days, then a notification with the days left
mkdir -p "$HOME_T/.local/state/icloud"
touch -d "1 day ago" "$HOME_T/.local/state/icloud/auth.stamp"; : > "$LOG"
in_env "$ROOT/bin/watch-icloud" < /dev/null; sleep 0.5
check "watch-icloud is silent for a fresh session" '! grep -q notify-send "$LOG"'
touch -d "27 days ago" "$HOME_T/.local/state/icloud/auth.stamp"
in_env "$ROOT/bin/watch-icloud" < /dev/null; sleep 0.5
check "watch-icloud warns from the 25th day with the days left" 'grep -q "notify-send .*expires in 3 days" "$LOG"'
touch -d "40 days ago" "$HOME_T/.local/state/icloud/auth.stamp"; : > "$LOG"
in_env "$ROOT/bin/watch-icloud" < /dev/null; sleep 0.5
check "watch-icloud says when the session has expired" 'grep -q "notify-send .*has expired" "$LOG"'
printf 'warn_after_days = 35\n' > "$T/options.toml"; touch -d "27 days ago" "$HOME_T/.local/state/icloud/auth.stamp"; : > "$LOG"
in_env "$ROOT/bin/watch-icloud" < /dev/null; sleep 0.5
check "the warning day comes from the options file" '! grep -q notify-send "$LOG"'
check "the reconnect button runs the script of the plugin" 'grep -q "readlink -f \"\$0\")\")/icloud-reconnect" "$ROOT/bin/watch-icloud" && grep -q "readlink -f \"\$0\")\")/icloud-reconnect" "$ROOT/bin/icloud-mount"'
stub rclone 'case "$1" in listremotes) ;; esac'
check "icloud-mount does nothing without the rclone remote" 'in_env "$ROOT/bin/icloud-mount" < /dev/null; [ $? = 0 ]'
check "manifest autostarts the mount" 'grep -q "^autostart = .*icloud-mount" "$ROOT/module.toml"'

exit "$fail"
