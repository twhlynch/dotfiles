#!/usr/bin/env bash

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>

ICON="󰊢"
IMPORTANT_ICON="󰀨"

gh_as() {
	local account="$1"
	shift

	(
		GH_TOKEN=$(gh auth token --user "$account") || exit 1
		export GH_TOKEN
		"$@"
	) &
}

fetch_data() {
	local tmpdir
	tmpdir=$(mktemp -d)

	for account in "$GH_USER" "$GH_USER_ALT"; do
		local suffix="$account"

		gh_as "$account" gh search prs \
			--author "@me" --state open --limit 50 \
			--json title,repository,url,createdAt \
			>"$tmpdir/author_$suffix.json"

		gh_as "$account" gh search prs \
			--owner "@me" --state open --limit 50 \
			--json title,repository,url,createdAt \
			>"$tmpdir/owner_$suffix.json"

		gh_as "$account" gh search prs \
			--review-requested "@me" --state open --limit 50 \
			--json url \
			>"$tmpdir/review_req_$suffix.json"

		gh_as "$account" gh search prs \
			--review changes_requested --author "@me" --state open --limit 50 \
			--json url \
			>"$tmpdir/change_req_$suffix.json"

		gh_as "$account" gh api user/repos \
			--paginate \
			--jq ".[] | select((.permission.push or .permissions.maintain or .permissions.admin) and .owner.login != \"$account\") | .full_name" \
			>"$tmpdir/collab_repos_$suffix.txt"
	done

	if ! wait; then
		rm -rf "$tmpdir"
		return 1
	fi

	local collab_index=0

	for account in "$GH_USER" "$GH_USER_ALT"; do
		local suffix="$account"

		while IFS= read -r repo; do
			((collab_index++))

			gh_as "$account" gh search prs \
				--repo "$repo" \
				--state open --limit 50 \
				--json title,repository,url,createdAt \
				>"$tmpdir/collab_$collab_index.json"
		done <"$tmpdir/collab_repos_$suffix.txt"
	done

	if ! wait; then
		rm -rf "$tmpdir"
		return 1
	fi

	AUTHOR=$(jq -s 'add' "$tmpdir"/author_*.json)
	OWNER=$(jq -s 'add' "$tmpdir"/owner_*.json)
	REVIEW_REQ=$(jq -s 'add' "$tmpdir"/review_req_*.json)
	CHANGE_REQ=$(jq -s 'add' "$tmpdir"/change_req_*.json)

	if ((collab_index > 0)); then
		COLLAB=$(jq -s 'add' "$tmpdir"/collab_*.json)
	else
		COLLAB='[]'
	fi

	rm -rf "$tmpdir"
	return 0
}

for delay in 0 10 30; do
	((delay > 0)) && sleep "$delay"
	fetch_data && break
done || {
	echo "$ICON"
	echo "---"
	echo "Open GitHub PRs | href=https://github.com/pulls"
	exit 0
}

ALL=$(echo "$AUTHOR" "$OWNER" "$COLLAB" | jq -s 'add | unique_by(.url)')
COUNT=$(echo "$ALL" | jq 'length')

IMPORTANT=$(echo "$REVIEW_REQ" "$CHANGE_REQ" | jq -s 'add | unique_by(.url)')
IMPORTANT_COUNT=$(echo "$IMPORTANT" | jq 'length')

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
