#!/bin/bash
#
[ -f ${HOME}/.private ] && source ${HOME}/.private
if [ "${ANTHROPIC_API_KEY}" ]; then
  export ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}"
else
  echo "WARN: ANTHROPIC_API_KEY not set"
fi

# Install llama
curl -LsSf https://llama.app/install.sh | sh

# Serve a model
have_llama=$(type -p llama)
if [ "${have_llama}" ]; then
  llama serve --port 10000 &
else
  echo "ERROR: cannot locate llama executable in PATH"
  exit 1
fi

# Install PI
have_npm=$(type -p npm)
if [ "${have_npm}" ]; then
  npm install -g --ignore-scripts --min-release-age=0 @earendil-works/pi-coding-agent
else
  echo "ERROR: cannot locate npm executable in PATH"
  exit 1
fi

# Install pi-llama
have_pi=$(type -p pi)
if [ "${have_pi}" ]; then
  pi install git:github.com/huggingface/pi-llama
else
  echo "ERROR: cannot locate pi executable in PATH"
  exit 1
fi

# Run Pi
pi
