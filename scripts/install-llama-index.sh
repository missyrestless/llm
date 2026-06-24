#!/bin/bash
#
export PYENV_ROOT="/mnt/llm/.venv"
export PATH="$PYENV_ROOT/bin:$PATH"

source ${PYENV_ROOT}/bin/activate

# By default, llama-index uses the OpenAI gpt-3.5-turbo model for text generation
# and text-embedding-ada-002 for retrieval and embeddings. In order to use this,
# you must have an OPENAI_API_KEY set up as an environment variable.
#
# This is a starter bundle of packages, containing:
#    llama-index-core
#    llama-index-llms-openai
#    llama-index-embeddings-openai
#    llama-index-readers-file
#
# pip install llama-index

# Local setup with Ollama and HuggingFace embeddings
pip install llama-index-core \
            llama-index-readers-file \
            llama-index-llms-ollama \
            llama-index-embeddings-huggingface

# There are many readers, agents, tools, and projects on LlamaHub at https://llamahub.ai
#
# For example, there is a Wikipedia reader with usage:
#
#     from llama_index.readers.wikipedia import WikipediaReader
#     reader = WikipediaReader()
#     documents = reader.load_data(pages=["Page Title 1", "Page Title 2", ...])
#
# To install:
# pip install llama-index-readers-wikipedia
#
# create-llama is a CLI that helps create a full-stack web application,
# indexes your documents, and allows you to chat with them
have_npx=$(type -p npx)
[ "${have_npx}" ] && npx create-llama@latest
