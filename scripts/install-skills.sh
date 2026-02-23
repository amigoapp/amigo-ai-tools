#!/bin/bash

# Copies shared rule files into each skill's references/ directory,
# runs the vercel-labs/skills installer (interactive — lets you pick agents),
# then removes the temporary copies regardless of success or cancellation.

set -e

SHARED_DIR="skills/shared"
SKILLS=("pr-review" "branch-review" "base-code-review")
SHARED_FILES=("security-rules.md" "review-criteria.md" "review-output-format.md")

cleanup() {
  echo "→ Cleaning up temporary references..."
  for skill in "${SKILLS[@]}"; do
    dest="skills/$skill/references"
    for file in "${SHARED_FILES[@]}"; do
      rm -f "$dest/$file"
    done
    rmdir "$dest" 2>/dev/null || true
  done
}

trap cleanup EXIT

echo "→ Copying shared files to skill references..."
for skill in "${SKILLS[@]}"; do
  dest="skills/$skill/references"
  mkdir -p "$dest"
  for file in "${SHARED_FILES[@]}"; do
    cp "$SHARED_DIR/$file" "$dest/$file"
  done
done

echo "→ Installing skills..."
npx --yes skills add . --copy -a claude-code -a cursor

echo "✓ Skills installed."
