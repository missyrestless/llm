#!/bin/bash

export PYENV_ROOT="/usr/local/share/llm/.venv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

source ${PYENV_ROOT}/bin/activate

pip install vllm

python3 -c "import vllm; print(vllm.__version__)"
