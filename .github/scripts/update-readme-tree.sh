#!/bin/bash
set -e

README="README.md"
START_TAG="<!-- BEGIN REPOSITORY TREE -->"
END_TAG="<!-- END REPOSITORY TREE -->"

# Only proceed if enough commits exist for a diff
if git rev-parse HEAD~1 >/dev/null 2>&1; then
  # Only update if a file/dir was Added (A), Deleted (D), or Renamed (R)
  # Ignore only the README.md in the repository root
  ADDED_DELETED_OR_RENAMED=$(git diff --name-status HEAD~1 HEAD | grep -E '^[ADR]' | grep -v "^[ADR][[:space:]]README.md$" || true)
  if [ -z "$ADDED_DELETED_OR_RENAMED" ]; then
    echo "No files or directories added, deleted, or renamed. Skipping README update."
    exit 0
  fi
else
  echo "Only one commit exists. Proceeding with README update."
fi

# Generate tree, ignoring .git, node_modules, and skip the root line
TREE=$(tree -a -I '.git|node_modules' | tail -n +2 | sed 's/^/    /')

# Build markdown section (No title, only tags and tree)
TREE_MD="$START_TAG
\`\`\`
$TREE
\`\`\`
$END_TAG"

# Insert or replace the tree section in README.md
if grep -q "$START_TAG" "$README"; then
  # Replace the section between tags
  awk -v start="$START_TAG" -v end="$END_TAG" -v new="$TREE_MD" '
    BEGIN {inblock=0}
    $0 ~ start {print new; inblock=1; next}
    $0 ~ end {inblock=0; next}
    !inblock {print}
  ' "$README" > "${README}.tmp" && mv "${README}.tmp" "$README"
else
  # Append to end
  echo -e "\n$TREE_MD" >> "$README"
fi
