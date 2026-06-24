#!/bin/bash
#
## Karpathy inspired Claude Code Guidelines
#
# A single CLAUDE.md file to improve Claude Code behavior, derived from Andrej Karpathy's
# observations on LLM coding pitfalls - https://github.com/multica-ai/andrej-karpathy-skills
#
## To use across all projects:
#
# From within Claude Code, first add the marketplace:
#   /plugin marketplace add forrestchang/andrej-karpathy-skills
# Then install the plugin:
#   /plugin install andrej-karpathy-skills@karpathy-skills
# This installs the guidelines as a Claude Code plugin, making the skill available across all your projects.
#
## To use per project copy the CLAUDE.md into the project folder
if [ -f CLAUDE.md ]; then
  echo "" >> CLAUDE.md
  curl -fsSL https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md >> CLAUDE.md
else
  curl -fsSL -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md
fi
