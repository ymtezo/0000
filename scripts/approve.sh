#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENTRIES_DIR="$REPO_ROOT/journal/entries"

filename="${1:?Usage: approve.sh <filename>}"
filepath="${ENTRIES_DIR}/${filename}"

if [ ! -f "$filepath" ]; then
    echo "Error: $filepath not found" >&2
    exit 1
fi

current_stage="$(sed -n 's/^stage: *//p' "$filepath")"
if [ "$current_stage" != "reflected" ]; then
    echo "Error: stage is '$current_stage', expected 'reflected'" >&2
    exit 1
fi

date_str="$(date +%Y-%m-%d)"

sed -i "s/^stage: reflected/stage: approved/" "$filepath"
sed -i "s/^approved_at: \"\"/approved_at: ${date_str}/" "$filepath"

git -C "$REPO_ROOT" add "$filepath"
git -C "$REPO_ROOT" commit -m "approve: ${filename}"

echo "Approved: $filepath"
