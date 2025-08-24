#!/bin/zsh
  curl -LsSf https://astral.sh/uv/install.sh | sh
  source $HOME/.local/bin/env
  uv tool install vectorcode

  uv tool install 'vectorcode[lsp,mcp]'
  
  npm install -g mcp-hub@latest
