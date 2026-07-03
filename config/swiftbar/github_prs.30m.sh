#!/usr/bin/env bash

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>

tmpdir=$(mktemp -d)

gh search prs \
	--author "@me" --state open --limit 50 \
	--json title,repository,url,createdAt \
	>"$tmpdir/author.json" &

gh search prs \
	--owner "@me" --state open --limit 50 \
	--json title,repository,url,createdAt \
	>"$tmpdir/owner.json" &

gh search prs \
	--review-requested "@me" --state open --limit 50 \
	--json url \
	>"$tmpdir/review_req.json" &

gh search prs \
	--review changes_requested --author "@me" --state open --limit 50 \
	--json url \
	>"$tmpdir/change_req.json" &

wait

AUTHOR=$(<"$tmpdir/author.json")
OWNER=$(<"$tmpdir/owner.json")
REVIEW_REQ=$(<"$tmpdir/review_req.json")
CHANGE_REQ=$(<"$tmpdir/change_req.json")

rm -rf "$tmpdir"

ALL=$(echo "$AUTHOR" "$OWNER" | jq -s 'add | unique_by(.url)')
COUNT=$(echo "$ALL" | jq 'length')

IMPORTANT=$(echo "$REVIEW_REQ" "$CHANGE_REQ" | jq -s 'add | unique_by(.url)')

IMPORTANT_COUNT=$(echo "$IMPORTANT" | jq 'length')

ICON="󰊢"
IMPORTANT_ICON="󰀨"

if [ "$IMPORTANT_COUNT" -gt 0 ]; then
	echo "$ICON $COUNT | color=#F85148"
else
	echo "$ICON $COUNT"
fi

echo "---"

echo "Open PRs: $COUNT | badge=$COUNT"
echo "Important PRs: $IMPORTANT_COUNT | badge=$IMPORTANT_COUNT"
echo "---"

FORMATTED=$(
	jq -n \
		--argjson all "$ALL" \
		--argjson important "$IMPORTANT" \
		--arg important_icon "$IMPORTANT_ICON" '
			$all
			| map(
				. as $pr
				| .important = (
					$important
					| any(.url == $pr.url)
				)
			)
			| map(
				.repoLabel = (
					.repository.name
					+ (if .important then " \($important_icon)" else "" end)
				)
			)
	'
)

MAX_LEN=$(
	echo "$FORMATTED" | jq '
		map(.repoLabel | length)
		| max
	'
)

echo "$FORMATTED" | jq -r --argjson max "$MAX_LEN" '
	sort_by(.createdAt)
	| reverse
	| .[]
	| (
		.repoLabel
		+ (" " * (($max - (.repoLabel | length)) + 2))
		+ .title
		+ " | href="
		+ .url
		+ " font=Menlo"
	)
'

echo "---"
echo "Open GitHub PRs | href=https://github.com/pulls"
