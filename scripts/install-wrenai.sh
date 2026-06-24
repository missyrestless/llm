#!/bin/bash
#
# Set this to your shell initializatin file (e.g. .bashrc, .zshrc, .profile, etc)
SHINIT="${HOME}"/.bashrc
#
LLM_HOME="/usr/local/share/llm"
export PYENV_ROOT="${LLM_HOME}/.venv"
export PATH="$PYENV_ROOT/bin:$PATH"

source ${PYENV_ROOT}/bin/activate

echo " ------------------------------------------------------------------ "
echo "| Installing NVM, Node.js, npx, and WrenAI                         |"
echo "| See https://docs.getwren.ai/oss/get_started/installation         |"
echo "| Start a new agent session, open your project directory, and ask: |"
echo "|     Use the /wren skill to install and set up Wren AI.           |"
echo " ------------------------------------------------------------------ "
# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ${SHINIT}
# Install Node.js
have_nvm=$(type -p nvm)
[ "${have_nvm}" ] && nvm install --lts
# Install WrenAI and discovery stub
pip install wrenai
have_npx=$(type -p npx)
if [ "${have_npx}" ]; then
  # auto-detects Claude Code, Cursor, Cline, Codex, …
  npx skills add Canner/WrenAI
else
  curl -fsSL https://raw.githubusercontent.com/Canner/WrenAI/main/skills/install.sh | bash
fi
