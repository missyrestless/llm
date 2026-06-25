#!/bin/bash
#
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

source ~/.bashrc

echo "Choose your LLM provider and model:"
printf "\thermes model\n"
echo "Configure which tools are enabled:"
printf "\thermes tools\n"
echo "Set up messaging platforms:"
printf "\thermes gateway setup\n"
echo "Set individual config values:"
printf "\thermes config set\n"
echo "Or run the full setup wizard to configure everything at once:"
printf "\thermes setup\n"

# Subscription:
# hermes setup --portal
