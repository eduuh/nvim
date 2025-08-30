## keymappings

> dap

- Down: Step over
- Right: Step into
- Left: Step out
- Up: Restart frame

### Primary Keymappings (leader) : Space

> dap

- <Leader> d -> all dap commands

> blink (cmp)

- ['<C-k>'] = { 'show', 'show_documentation', 'hide_documentation' },
- ['<C-e>'] = { 'hide', 'fallback' },
- ['<CR>'] = { 'accept', 'fallback' },
- ['<Tab>'] = { 'snippet_forward', 'fallback' },
- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
- ['<Up>'] = { 'select_prev', 'fallback' },
- ['<Down>'] = { 'select_next', 'fallback' },
- ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
- ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
- ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },

### Secondary Keymappings (leader) : Semi Collon

- ;; -> File Manager (oil)
- ;c -> Lazy Git (commit)
- ;r -> Competitest run (c++, c, cs, ts, js ,rs)
- ;a -> Competitest add test cases
- ;s -> scratch notes

> dap

- ;d -> start dap debug
- ;b -> add break point
- ;B -> add conditonal break point
- ;i -> step into
- ;o -> step over

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
