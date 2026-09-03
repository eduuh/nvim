## Eduuh Nvim Config

Personal Neovim 0.12 configuration. Built around `vim.pack` + lazy.nvim
(hybrid), with LSP/DAP for C/C++, Rust, Lua, and TypeScript/JavaScript, plus
Magenta for agentic AI workflows.

JavaScript and TypeScript support includes TypeScript IntelliSense, ESLint
diagnostics and fixes, Prettier formatting, inlay hints, import/refactor code
actions, and Node/Chrome/Jest/Vitest debugging. Project-specific
`.vscode/launch.json` files are supported.

Custom LuaSnip snippets live in `snippets/<filetype>.lua`. The included
JavaScript snippets are shared with TypeScript and React filetypes.

## Setup

`scripts/install-deps.sh` provisions everything Neovim will not install for
itself — the `tree-sitter` CLI (without which no parser builds), a C toolchain,
`ripgrep`/`fzf`/`fd`, `clangd`, Node.js and Rust — then runs Neovim headlessly to
drive lazy.nvim, mason and the tree-sitter parsers to completion and verify the
result. It supports Debian/Ubuntu and macOS, and is safe to re-run.

```sh
scripts/install-deps.sh --check   # report what is missing, change nothing
scripts/install-deps.sh           # install and verify
```

The tool lists live in `lua/config/deps.lua`, shared by the runtime config and
the installer so the two cannot drift.

Magenta requires Node.js and either `ANTHROPIC_API_KEY` or Claude Max
authentication. Press `<leader>mt` to open its sidebar.

See the printable [Neovim + Rsbuild cheat sheet](docs/nvim-rsbuild-cheat-sheet.pdf)
for the daily debugging, testing, WebSocket, and snippet workflows.
`docs/keymaps.md` contains the full keymap reference, and
`docs/vim-features.md` surveys underused Vim features.
