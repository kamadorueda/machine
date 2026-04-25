#!/usr/bin/env bash
exec node "$NODEMODULES/node_modules/@anthropic-ai/claude-code/cli-wrapper.cjs" \
  --allow-dangerously-skip-permissions \
  "$@"
