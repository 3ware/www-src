#!/usr/bin/env bash

# Check for any GitHub Action workflow changes. If none, exit early.
# Otherwise, install the GitHub CLI gh-actions-lock extension (if not already installed)
# and verify the actions lock file.

set -euo pipefail

if git diff --cached --quiet -- .github/workflows/ ':(glob)**/action.yml' ':(glob)**/action.yaml'; then
	exit 0
fi

extensions=$(gh extension list)
if ! grep -q 'github/gh-actions-lock' <<<"${extensions}"; then
	read -r version <.github/gh-actions-lock.version
	gh extension install github/gh-actions-lock --pin "${version}"
fi

gh actions-lock --verify-local --no-fix
