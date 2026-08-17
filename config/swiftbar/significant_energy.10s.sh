#!/usr/bin/env bash

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>

THRESHOLD=90      # show icon
HIGH_THRESHOLD=99 # show icon red
POWER_ICON=":bolt.fill:"
COLOR="#F85148"

processes=$(
	ps -axo pid=,pcpu=,comm= |
		awk -v threshold="$THRESHOLD" '
		$2 >= threshold {
			name = $3
			for (i = 4; i <= NF; i++)
				name = name " " $i

			sub(/^.*\//, "", name)

			printf "%s\t%.0f\t%s\n", $1, $2, name
		}'
)

[[ -z "$processes" ]] && exit 0

if echo "$processes" | awk -F '\t' -v threshold="$HIGH_THRESHOLD" '
	$2 >= threshold { found=1 }
	END { exit !found }
'; then
	echo "$POWER_ICON | sfcolor=$COLOR"
else
	echo "$POWER_ICON"
fi

echo "---"

echo "$processes" | while IFS=$'\t' read -r pid cpu name; do
	echo "$cpu%	$name ($pid) | bash='kill' param0='$pid' terminal=false"
done
