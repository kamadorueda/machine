#!/usr/bin/env bash
exec node "$NODEMODULES/node_modules/@anthropic-ai/claude-code/cli.js" \
  --allow-dangerously-skip-permissions \
  "$@"
