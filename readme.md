## Eduuh Nvim Config

## Workflow

- Search via LSP first (slow). Then pattern matching with fzf.
- Replace with LSP first (slow). Replace By pattern matching.
- Fuzzy search Results (list) using fzf-lua. First to search

### LSP & Pattern Matching Keybindings

### lsp + fzf?

- <leader>fs file symbols
- <leader>ws workspace symbols
- gr lsp references
- gi lsp implementations
- gt lsp type definitions
- <leader>ca lsp code action
- <leader>rn lsp rename
- <leader>lr lsp restart

- <leader>ts treesitter symbols

- [d Prev diagnostic jump
- ]d Next diagnostic jump
- <leader>wd workspace diagnostics

- <leader>ff find files
- <leader>fo find oldfiles
- <leader>fr find registers
- <leader>fw find word
- <leader>fb find buffers

- gb git blame line
- gB git blame file
- gn git next hunk
- gp git prev hunk
- gs git stage hunk
- gx toggle deleted files
- <leader>gr reset hunk
- <leader> gc git commits (fzf)
- <leader> gb git branch (fzf)
- <leader> gs git stash (fzf)

- ;d dap commands
- <leader>db dap (list/delete) breakpoints
- ;b toggle breakpoint

### Debugging Simple files

1. C++ & C

2. Rust

3. JavaScript & Typescript

### Things Not for my editor

I have tried these things and they are not well suited to be part of the
editor.

1. Image visualizations. i.e plantuml & pngs or jpegs
   - Not all terminal support image visualization. Found to be slow.
   - I use markdown (prefer preview markdown in website)
