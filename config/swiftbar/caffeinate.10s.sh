#!/usr/bin/env bash

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>

pgrep caffeinate &>/dev/null || exit 0

B64_ICON="$(base64 <"$HOME/dotfiles/config/swiftbar/paper-cup-filled.png" | tr -d '\n')"

echo " | image=$B64_ICON bash='killall' param0='caffeinate' terminal=false refresh=true"
