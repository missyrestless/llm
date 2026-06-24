#!/bin/bash
#
# Set the Python version to install in the virtual environment
LLM_SHARE="/usr/local/share"
LLM_HOME="${LLM_SHARE}/llm"

export PYENV_ROOT="${LLM_HOME}/.venv"

export PATH="$PYENV_ROOT/bin:$PATH"

source ${PYENV_ROOT}/bin/activate

pip install open-terminal

printf "\nRun:\n\topen-terminal run --host 127.0.0.1 --port 9000 --api-key your-secret-key\n"
