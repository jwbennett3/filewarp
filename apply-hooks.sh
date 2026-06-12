#!/bin/bash
set -e

HOOKS_DIR="$(cd "$(dirname "$0")" && pwd)/hooks"
GIT_DIR="$(cd "$(dirname "$0")" && pwd)/.git"

if [[ ! -d "$GIT_DIR" ]]; then
  echo "no .git directory found"
  exit 1
fi

for hook in "$HOOKS_DIR"/*; do
  if [[ -f "$hook" ]]; then
    ln -sf "$hook" "$GIT_DIR/hooks/$(basename "$hook")"
    echo "  installed hook: $(basename "$hook")"
  fi
done

echo "hooks installed"
