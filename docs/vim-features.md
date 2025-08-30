# Important Vim Feature

## Movement & Editing

Learn motions and text objects (ciw, di", yap) → edit code faster than arrowing/selecting.

Visual Block (Ctrl+v) → align columns, edit multiple lines.

## Searching

/pattern and n / N for next/prev.

- / # to jump to next/prev occurrence of word under cursor.

## Buffers & Tabs

:ls, :bnext, :bprev → think "buffers = files," "tabs = layouts."

## Undo Tree

u, Ctrl+r, and g-/g+ → move in undo history.

## Macros

Automate repetitive edits (qa ... q, @a).

## Marks

Jump between important code spots ( `a).

## Substitution

:%s/foo/bar/gc → project-wide replacements.

## Quickfix & Location Lists

Populate with :grep or compiler errors, navigate with :cnext, :cprev.

## Argument List

:args src/\*_/_.ts + :argdo %s/old/new/g | update → batch refactors.

Surround Editing (plugin: vim-surround or mini.surround)

cs"' → change quotes.

ysiw] → wrap word in brackets.

## Treesitter Text Objects

Operate on functions, classes, blocks directly (af, if, etc.).

## Fuzzy Finding (plugins: Telescope/FZF)

:Telescope find_files, :Telescope live_grep → jump anywhere instantly.

## Git Integration (gitsigns.nvim)

Stage/revert hunks inline, check blame per line.

## LSP (nvim-lspconfig)

Jump to definition (gd), references (gr), hover docs (K).

Code actions and formatting with :lua vim.lsp.buf.code_action().

## Debugging (nvim-dap)

Place breakpoints, step into/over (F10, F11), inspect variables in-Vim.

## Multiple Cursors (vim-visual-multi)

Edit multiple places like VSCode multi-cursors.

## Sessions & Projects

Save/restore project state (:mksession!, :source).
