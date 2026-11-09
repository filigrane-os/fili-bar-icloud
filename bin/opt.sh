# shellcheck shell=sh
# opt KEY DEFAULT: value of KEY in the options file of this plugin (flat "key = value" TOML), else DEFAULT.
# The file is ~/.config/filigrane/bar/icloud.toml (never in this repository); see config.example.toml.
opt() {
    _f="${FILI_BAR_OPTIONS:-$HOME/.config/filigrane/bar/icloud.toml}"
    _v="$(sed -n "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*//p" "$_f" 2>/dev/null | head -1 | sed -e 's/[[:space:]]*#.*//' -e 's/^"\(.*\)"$/\1/')"
    _v="${_v:-$2}"
    case "$_v" in "~/"*) _v="$HOME/${_v#"~/"}" ;; esac
    printf '%s' "$_v"
}
