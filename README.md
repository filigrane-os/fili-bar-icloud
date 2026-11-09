# icloud (fili-bar plugin)

iCloud Drive mounted in `~/iCloud` with `rclone mount` (cache capped, tree kept for 1 h), a bar indicator when it is not mounted, and a reminder before the Apple session expires (30 days).

```sh
fili-bar install https://github.com/filigrane-os/fili-bar-icloud
rclone config        # remote "icloud", type iclouddrive (password + 2FA)
```

The daemon starts at login by itself (`autostart` in `module.toml`, run by niri through `fili-bar autostart`). For the daily session reminder, add a `cron-watch` job that runs `bin/watch-icloud`; `bin/icloud-reconnect` renews the session (interactive).

`fili-bar install` also runs `install.sh`: it creates your options file from `config.example.toml`, asks for what is missing (credentials go to the keyring or to a file under `~/.config`, never to this folder) and prints what is left to do. Run it again with `fili-bar setup icloud`; it is safe to repeat.

## Personal data

Apple credentials stay in the rclone config (`~/.config/rclone/`), outside this repository. Options: copy `config.example.toml` to `~/.config/filigrane/bar/icloud.toml`.
