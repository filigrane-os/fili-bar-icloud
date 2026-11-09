# icloud (fili-bar plugin)

iCloud Drive mounted in `~/iCloud` with `rclone mount` (cache capped, tree kept for 1 h), a bar indicator when it is not mounted, and a reminder before the Apple session expires (30 days).

```sh
fili-bar install https://github.com/filigrane-os/fili-bar-icloud
rclone config        # remote "icloud", type iclouddrive (password + 2FA)
```

The daemon starts at login by itself (`autostart` in `module.toml`, run by niri through `fili-bar autostart`). For the daily session reminder, add a `cron-watch` job that runs `bin/watch-icloud`; `bin/icloud-reconnect` renews the session (interactive).

`fili-bar install` also runs `install.sh`: it creates your options file from `config.example.toml`, asks for what is missing (credentials go to the keyring or to a file under `~/.config`, never to this folder) and prints what is left to do. Run it again with `fili-bar setup icloud`; it is safe to repeat.

## Packages

Declared in `module.toml` (`packages`), installed by `fili-bar install --yes`: `rclone` (~106 MB on disk; the mount is resident, ~50-90 MB).

## Personal data

Apple credentials stay in the rclone config (`~/.config/rclone/`), outside this repository. Options: copy `config.example.toml` to `~/.config/filigrane/bar/icloud.toml`.

## Tests

```sh
sh tests/run.sh
```

No network and no real account: the external commands (`notify-send`, `secret-tool`, `rclone`, `ip`...) are stubs and `HOME` is a temporary folder. The checks every plugin passes (manifest, scripts parse, no personal data in the repository, `install.sh` idempotent) are in `tests/common.sh`; GitHub Actions runs them on each push.
