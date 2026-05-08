#!/usr/bin/env bash
# PreToolUse hook: block Bash commands that mutate GitHub state or push
# to a git remote, unless the user has explicitly authorized the specific
# command in this conversation.
#
# Blocked:
#   gh pr create|close|reopen|merge|comment|review|edit
#   gh issue create|close|reopen|comment|edit
#   gh release create|delete
#   git push (any form)
#   gh api with a mutating method (-X POST/PATCH/PUT/DELETE or --method=...)

set -euo pipefail

command=$(jq -r '.tool_input.command // empty')
if [ -z "$command" ]; then
  exit 0
fi

# Segment-start: beginning of the command, or right after a shell
# separator (&&, ||, ;, |, opening paren). Using bash =~ with ERE so we
# don't depend on grep -P (BSD grep doesn't support it).
seg='(^|[&|;(])[[:space:]]*'

deny_re="${seg}(gh[[:space:]]+pr[[:space:]]+(create|close|reopen|merge|comment|review|edit)|gh[[:space:]]+issue[[:space:]]+(create|close|reopen|comment|edit)|gh[[:space:]]+release[[:space:]]+(create|delete)|git[[:space:]]+push)([[:space:]]|$)"

api_re="${seg}gh[[:space:]]+api[[:space:]]+[^;|&]*(-X[[:space:]]+|--method([[:space:]]+|=))(POST|PATCH|PUT|DELETE)([[:space:]]|$|[^A-Z])"

if [[ "$command" =~ $deny_re ]] || [[ "$command" =~ $api_re ]]; then
  echo "BLOCKED: This command affects shared state or is externally visible. You must obtain explicit user authorization in this conversation before running it. Ask the user, do not retry." >&2
  exit 2
fi

exit 0
