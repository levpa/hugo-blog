#!/usr/bin/env bash
set -euo pipefail

CHLOG_LENGTH="${CHLOG_LENGTH:-20}"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
VERSION="$(git describe --tags --abbrev=0)"
DATE="$(date '+%Y-%m-%d')"
OUT="CHANGELOG.md"
SEEN=".chlog-seen"

# Header
echo -e "# Changelog for $VERSION\n" > "$OUT"
echo -e "## Date: $DATE\n" >> "$OUT"
rm -f "$SEEN"

# ✨ Features
echo -e "### ✨ Features\n" >> "$OUT"
git log -n "$CHLOG_LENGTH" --grep="^feat" --pretty=format:"- %h %d %s (%ad)" --date=relative \
  | tee -a "$OUT" | cut -d' ' -f2 >> "$SEEN"
echo "" >> "$OUT"

# 🐛 Fixes
echo -e "\n### 🐛 Fixes\n" >> "$OUT"
git log -n "$CHLOG_LENGTH" --grep="^fix" --pretty=format:"- %h %d %s (%ad)" --date=relative \
  | tee -a "$OUT" | cut -d' ' -f2 >> "$SEEN"
echo "" >> "$OUT"

# 🧹 Chores & Refactors
echo -e "\n### 🧹 Chores\n" >> "$OUT"
git log -n "$CHLOG_LENGTH" --grep="^chore" --pretty=format:"- %h %d %s (%ad)" --date=relative \
  | tee -a "$OUT" | cut -d' ' -f2 >> "$SEEN"
echo "" >> "$OUT"

# 📌 Other Commits
echo -e "\n### 📌 Other Commits\n" >> "$OUT"
git log -n "$CHLOG_LENGTH" --pretty=format:"- %h %d %s (%ad)" --date=relative | while read -r line; do
  hash=$(echo "$line" | cut -d' ' -f2)
  grep -q "$hash" "$SEEN" || echo "$line" >> "$OUT"
done

# Cleanup commit decorations
sed -i -E \
  -e 's/HEAD -> [^,)]+,? ?//g' \
  -e 's/origin\/[^,)]+,? ?//g' \
  -e 's/HEAD,? ?//g' \
  -e 's/origin\/HEAD,? ?//g' \
  -e 's/ ,/,/g' \
  -e 's/, \)/)/g' \
  "$OUT"

rm -f "$SEEN"
cat "$OUT"
