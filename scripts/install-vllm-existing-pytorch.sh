#!/bin/bash
#
export PYENV_ROOT="/usr/local/share/llm/.venv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

have_uv=$(type -p uv)
if [ "${have_uv}" ]; then
  source ${PYENV_ROOT}/bin/activate
  [ -d ${HOME}/src ] || mkdir -p ${HOME}/src
  cd ${HOME}/src
  [ -d vllm ] && {
    echo "Moving existing ${HOME}/src/vllm to ${HOME}/src/vllm$$"
    mv vllm vllm$$
  }
  git clone https://github.com/vllm-project/vllm.git
  cd vllm
  python use_existing_torch.py
  uv pip install -r requirements/build/cuda.txt
  uv pip install --no-build-isolation -e .
else
  echo "ERROR: cannot locate uv in execution PATH"
  exit 1
fi
