#!/usr/bin/env bash
# PreToolUse hook: block bare pip/pip3 and bare python/python3 in Bash commands.
#
# Rules:
#   - pip/pip3 as a command is NEVER allowed. Use "uv pip" instead.
#   - python/python3 is only allowed if "source .venv/bin/activate" (or similar)
#     appears earlier in the same command.

set -euo pipefail

command=$(jq -r '.tool_input.command // empty')

if [ -z "$command" ]; then
  exit 0
fi

# Ban bare pip/pip3: matches pip or pip3 at the start of a command segment.
# Command segments are separated by &&, ||, ;, |, or start of string.
# Does NOT match "uv pip" because pip is not at the segment start.
if echo "$command" | grep -qP '(^|[&|;(]\s*)\s*pip[0-9]*\b'; then
  echo "Bare 'pip' is not allowed. Prepend 'source [PROJECT_ROOT]/.venv/bin/activate &&' and use 'uv pip' instead." >&2
  exit 2
fi

# Ban bare python/python3: only allowed if "source .../activate" appears
# in the same command (meaning the venv was activated in this invocation).
if echo "$command" | grep -qP '(^|[&|;(]\s*)\s*python[0-9.]*\b'; then
  if ! echo "$command" | grep -qP 'source\s+\S*/activate'; then
    echo "Bare 'python' is not allowed. Prepend 'source [PROJECT_ROOT]/.venv/bin/activate &&' and use either 'uv run' or 'python'." >&2
    exit 2
  fi
fi

exit 0
