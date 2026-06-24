#!/bin/bash
#
curl -fsSL https://raw.githubusercontent.com/BerriAI/litellm/main/scripts/install.sh | sh

uv tool install 'litellm[proxy]'
