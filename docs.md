# Important Vim Feature

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

- ;; -> File Manager
- ;c -> Lazy Git (commit)
- ;r -> Competitest run (c++, c, cs, ts, js ,rs)
- ;a -> Competitest add test cases

> dap

- ;d -> start dap debug
- ;b -> add break point
- ;B -> add conditonal break point
- ;i -> step into
- ;o -> step over
