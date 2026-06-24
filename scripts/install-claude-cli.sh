#!/bin/bash
#
have_npm=$(type -p npm)
if [ "${have_npm}" ]; then
  npm config set allow-scripts=@anthropic-ai/claude-code --location=user
  npm install -g @anthropic-ai/claude-code
else
  curl -fsSL https://claude.ai/install.sh | bash
fi
