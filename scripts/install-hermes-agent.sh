#!/bin/bash
#
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

source ~/.bashrc

hermes model

# Subscription:
# hermes setup --portal
