#!/usr/bin/env bash

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>

AUTHOR=$(gh search prs --author "@me" --state open --limit 50 \
	--json number,title,repository,url,createdAt)
OWNER=$(gh search prs --owner "@me" --state open --limit 50 \
	--json number,title,repository,url,createdAt)

IMPORTANT=$(gh search prs --review-requested "@me" --state open --limit 50 \
	--json number)

ALL=$(echo "$AUTHOR" "$OWNER" | jq -s 'add | unique_by(.url)')
COUNT=$(echo "$ALL" | jq 'length')

IMPORTANT_COUNT=$(echo "$IMPORTANT" | jq 'length')

ICON="󰊢"

if [ "$IMPORTANT_COUNT" -gt 0 ]; then
	echo "$ICON $COUNT | color=#F85148"
else
	echo "$ICON $COUNT"
fi

echo "---"

echo "Open PRs: $COUNT | badge=$COUNT"
echo "Important PRs: $IMPORTANT_COUNT | badge=$IMPORTANT_COUNT"
echo "---"

echo "$ALL" | jq -r '
	sort_by(.createdAt)
	| reverse
	| .[]
	| "\(.repository.nameWithOwner): \(.title) | href=\(.url)"'

echo "---"
echo "Open GitHub PRs | href=https://github.com/pulls"
