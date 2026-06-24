#!/bin/bash
#
# Download Ollama models

MNT_SHARE="/mnt/llm/share"
# Ollama models folder on separate disk
export OLLAMA_MODELS="${MNT_SHARE}/models"
# Log to this directory
LOGDIR="/mnt/llm/logs"

info() { printf "\n%b[info]%b %s" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
erro() { printf "\n%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

[ -d "${OLLAMA_MODELS}" ] || mkdir -p "${OLLAMA_MODELS}"
[ -d "${LOGDIR}" ] || mkdir -p "${LOGDIR}"
echo "Ollama Pull Log" > ${LOGDIR}/ollama-models-pull.log
echo "---------------" >> ${LOGDIR}/ollama-models-pull.log

have_ollama=$(type -p ollama)
if [ "${have_ollama}" ]; then
  for model in deepseek-v3.2:cloud \
               deepseek-v4-pro:cloud \
               gemma4:e4b \
               glm-5.1:cloud \
               kimi-k2.7-code:cloud \
               llama3-groq-tool-use:8b \
               llama3.2:3b \
               mistral:instruct \
               mistral-medium-3.5 \
               phi4 \
               qwen2.5-coder:7b \
               qwen3-coder:30b \
               qwen3.6 \
               SetneufPT/Gemma4-12B_Q4_64K_16GB-GPU:latest
  do
    info "Pulling ${model} model, please be patient"
    echo "Pulling ${model} model" >> ${LOGDIR}/ollama-models-pull.log
    ollama pull ${model} 2>&1 >> ${LOGDIR}/ollama-models-pull.log
    echo "----------------------" >> ${LOGDIR}/ollama-models-pull.log
  done
else
  erro "Ollama not found. Correct errors in 'curl -fSL https://ollama.com/install.sh | sh'"
fi

echo "Ollama Models List:"  > ${HOME}/ollama-models-list.txt 2>&1
ollama list >> ${HOME}/ollama-models-list.txt 2>&1
