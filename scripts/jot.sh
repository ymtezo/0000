#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENTRIES_DIR="$REPO_ROOT/journal/entries"
TEMPLATE="$REPO_ROOT/journal/templates/entry.md"

slug="${1:-entry}"
date_str="$(date +%Y-%m-%d)"
id="$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen 2>/dev/null || date +%s)"
filename="${date_str}-${slug}.md"
filepath="${ENTRIES_DIR}/${filename}"

if [ -f "$filepath" ]; then
    echo "Error: $filepath already exists" >&2
    exit 1
fi

sed -e "s/^id: \"\"/id: \"${id}\"/" \
    -e "s/^date: \"\"/date: ${date_str}/" \
    "$TEMPLATE" > "$filepath"

echo "Created: $filepath"

if [ -n "${EDITOR:-}" ]; then
    "$EDITOR" "$filepath"
fi

printf "git add & commit? [y/N] "
read -r answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    git -C "$REPO_ROOT" add "$filepath"
    git -C "$REPO_ROOT" commit -m "journal: add ${filename}"
fi
