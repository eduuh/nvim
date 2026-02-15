#!/bin/zsh
  curl -LsSf https://astral.sh/uv/install.sh | sh
  source $HOME/.local/bin/env
  uv tool install vectorcode

  uv tool install 'vectorcode[lsp,mcp]'
  
  npm install -g mcp-hub@latest

  # tree-sitter CLI (required by nvim-treesitter on nvim 0.12+ to compile parsers)
  # Using v0.24.7 for GLIBC 2.35 compatibility (WSL2 Ubuntu 22.04)
  curl -sL https://github.com/tree-sitter/tree-sitter/releases/download/v0.24.7/tree-sitter-linux-x64.gz -o /tmp/tree-sitter.gz
  gunzip -f /tmp/tree-sitter.gz
  chmod +x /tmp/tree-sitter
  mv /tmp/tree-sitter ~/.local/bin/tree-sitter
