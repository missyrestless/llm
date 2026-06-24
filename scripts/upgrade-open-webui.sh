#!/bin/bash
#
export PATH="/usr/local/share/llm/.venv/bin:${PATH}"

source ${PYENV_ROOT}/bin/activate

have_pip=$(command -v pip)
if [ "${have_pip}" ]; then
  pip install --upgrade pip
  pip install --upgrade open-webui
else
  echo "ERROR: cannot locate pip. Exiting."
  exit 1
fi
