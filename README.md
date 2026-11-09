# icloud (fili-bar plugin)

iCloud Drive mounted in `~/iCloud` with `rclone mount` (cache capped, tree kept for 1 h), a bar indicator when it is not mounted, and a reminder before the Apple session expires (30 days).

```sh
fili-bar install https://github.com/filigrane-os/fili-bar-icloud
rclone config        # remote "icloud", type iclouddrive (password + 2FA)
```

Start `bin/icloud-mount` at login; run `bin/watch-icloud` once a day (cron-watch) for the reminder; `bin/icloud-reconnect` renews the session (interactive).

## Personal data

Apple credentials stay in the rclone config (`~/.config/rclone/`), outside this repository. Options: copy `config.example.toml` to `~/.config/filigrane/bar/icloud.toml`.
