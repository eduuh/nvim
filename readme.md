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

Magenta requires Node.js and either `ANTHROPIC_API_KEY` or Claude Max
authentication. Press `<leader>mt` to open its sidebar.

See `docs/keymaps.md` for the full keymap reference and `docs/vim-features.md`
for a survey of underused Vim features.
