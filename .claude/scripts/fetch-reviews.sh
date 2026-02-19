#!/usr/bin/env bash
set -euo pipefail

PR_NUM="${1:-}"
if [ -z "$PR_NUM" ]; then
    PR_NUM=$(gh pr view --json number -q .number)
fi

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

echo "PR #$PR_NUM ($REPO)"
echo "---"
gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/$REPO/pulls/$PR_NUM/comments"
