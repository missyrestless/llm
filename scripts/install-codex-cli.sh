#!/bin/bash
#
have_npm=$(type -p npm)
if [ "${have_npm}" ]; then
# npm config set allow-scripts=@anthropic-ai/claude-code --location=user
  npm install -g @openai/codex
else
  echo "ERROR: cannot locate npm in execution PATH"
  exit 1
fi
