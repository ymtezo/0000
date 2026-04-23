#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENTRIES_DIR="$REPO_ROOT/journal/entries"

stage_filter="${1:-}"

printf "%-12s %-10s %-12s %s\n" "DATE" "STAGE" "CATEGORY" "FILE"
printf "%-12s %-10s %-12s %s\n" "----" "-----" "--------" "----"

for f in "$ENTRIES_DIR"/*.md; do
    [ -f "$f" ] || continue

    date="$(sed -n 's/^date: *//p' "$f")"
    stage="$(sed -n 's/^stage: *//p' "$f")"
    category="$(sed -n 's/^category: *//p' "$f")"
    basename="$(basename "$f")"

    if [ -n "$stage_filter" ] && [ "$stage" != "$stage_filter" ]; then
        continue
    fi

    printf "%-12s %-10s %-12s %s\n" "$date" "$stage" "$category" "$basename"
done
