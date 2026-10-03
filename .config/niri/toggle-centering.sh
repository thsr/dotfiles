#!/bin/sh
config="$HOME/dotfiles/.config/niri/config.kdl"

sed -i -E '
s/^([[:space:]]*center-focused-column[[:space:]]+)"always"/\1"on-overflow"/
t
s/^([[:space:]]*center-focused-column[[:space:]]+)"on-overflow"/\1"always"/
' "$config"
