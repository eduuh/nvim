# Keymap reference — practice guide

A printable workflow-oriented cheat sheet for this Neovim 0.12 config.
Mixes built-in defaults (what every nvim user should eventually internalize)
with the custom bindings this config adds. Use it to practice one section at
a time until the motions feel automatic.

> Leader = `Space`, LocalLeader = `\`.

---

## 1. Motions you should be automatic at

Default Vim motion set. If any of these feels slow, drill them first — nothing
else pays off until these are reflex.

| Key | Action |
|-----|--------|
| `h j k l` | Left / down / up / right |
| `w W` | Next word start (word / WORD) |
| `b B` | Prev word start |
| `e E` | Next word end |
| `0` | First column |
| `^` | First non-blank |
| `$` | End of line |
| `g_` | End of line, non-blank |
| `gg` / `G` | File start / end |
| `{` / `}` | Prev / next paragraph |
| `(` / `)` | Prev / next sentence |
| `H M L` | Viewport top / middle / bottom |
| `zz zt zb` | Center / top / bottom the cursor line |
| `<C-u>` / `<C-d>` | Half-page up / down |
| `<C-b>` / `<C-f>` | Full-page up / down |
| `<C-e>` / `<C-y>` | Scroll one line |
| `f{c}` / `F{c}` | Next / prev char on line |
| `t{c}` / `T{c}` | Till next / prev char |
| `;` / `,` | Repeat / reverse last f/t |
| `%` | Jump to matching pair (matchit) |
| `*` / `#` | Search word under cursor forward / back |
| `n` / `N` | Repeat / reverse last search |

### Jumplist & changelist
| Key | Action |
|-----|--------|
| `<C-o>` | Jumplist back |
| `<C-i>` | Jumplist forward |
| `g;` | Changelist back |
| `g,` | Changelist forward |

> This config has `jumpoptions+=view` → jumplist navigation restores your
> viewport, not just the cursor row.

### Marks
| Key | Action |
|-----|--------|
| `m{a-z}` | Set local mark |
| `m{A-Z}` | Set global mark (cross-file) |
| `` `{a-z} `` | Jump to mark |
| `''` | Jump to last position |
| `` `` `` | Same |

---

## 2. Text objects

Text objects combine with operators. `d`, `c`, `y`, `v` all take them.
Shape: `<op>{i|a}<object>` where `i` = inner, `a` = outer (includes surround).

### Built-in
| Object | Inner / outer |
|--------|---------------|
| `w` | word |
| `W` | WORD (whitespace-delimited) |
| `s` | sentence |
| `p` | paragraph |
| `"` `'` `` ` `` | quoted string |
| `(` `)` `b` | parens / round brackets |
| `[` `]` | square brackets |
| `{` `}` `B` | curly braces |
| `<` `>` | angle brackets |
| `t` | xml tag contents |

---

## 3. Editing (operators + intent)

| Key | Action |
|-----|--------|
| `i I` | Insert before cursor / line start |
| `a A` | Append after cursor / line end |
| `o O` | New line below / above |
| `x` | Delete char under cursor |
| `X` | Delete char before cursor |
| `r{c}` | Replace one char |
| `R` | Enter replace mode |
| `d{motion}` | Delete motion (`dd` line, `D` to EOL) |
| `c{motion}` | Change motion (`cc` line, `C` to EOL) |
| `y{motion}` | Yank motion (`yy` line, `Y` to EOL) |
| `p` / `P` | Paste after / before cursor |
| `u` | Undo |
| `<C-r>` | Redo |
| `.` | Repeat last change |
| `>{motion}` / `<{motion}` | Shift indent |
| `={motion}` | Auto-indent |
| `gu{motion}` / `gU{motion}` | Lowercase / uppercase |
| `~` | Toggle case |
| `J` | Join line with next |
| `gJ` | Join without space |

### Visual mode tricks
| Key | Action |
|-----|--------|
| `v V <C-v>` | Visual char / line / block |
| `gv` | Re-select last visual |
| `o` | Swap cursor end in visual |
| `:'<,'>s//…` | Substitute in selection |

### Surround (nvim-surround)
| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surround |
| `cs{old}{new}` | Change surround |
| `ds{char}` | Delete surround |
| `yss{char}` | Surround whole line |
| `S{char}` | Surround visual selection |

Examples: `ysiw"` quotes the word. `cs"'` changes double to single. `ds(` deletes parens.

---

## 4. Find, navigate, jump

### Fuzzy finder (fzf-lua)
| Key | Action |
|-----|--------|
| `<C-p>` | Find files |
| `<leader>ff` | Find files (alt) |
| `<leader>fw` | Live grep across project |
| `<leader>fo` | Recent files |
| `<leader>fr` | Registers |
| `<leader>wd` | Workspace diagnostics |
| `<leader>ql` | Quickfix list |
| `<leader>qs` | Quickfix stack |

Inside the fzf picker:
- `<C-q>` — select all + accept (send to quickfix)
- `<C-s>` / `<C-v>` — open in h-split / v-split
- `<C-h>` — toggle hidden files

### Flash (motion on steroids)
| Key (n/x/o) | Action |
|-------------|--------|
| `s` | Flash jump anywhere on screen |
| `r` (op-pending) | Remote flash (operate on distant text) |
| `<C-s>` (cmdline) | Toggle flash search |

**Practice drill**: instead of hunting with `f{c};;;`, do `s{c}{c}` to jump
two chars anywhere. Much faster once your fingers commit.

### File explorer (oil.nvim)
| Key | Action |
|-----|--------|
| `;;` | Open oil in current file's directory |
| `-` (inside oil) | Go up a directory |
| `<CR>` (inside oil) | Enter file / dir |
| `g?` (inside oil) | Show all oil bindings |

Oil replaces netrw — `nvim .` on a directory also lands in an oil buffer
that you can edit like text (create files by adding lines, rename by
editing, delete by removing lines, `:w` applies).

### Quickfix & location list
| Key | Action |
|-----|--------|
| `;n` | Next quickfix entry |
| `;p` | Prev quickfix entry |
| `:copen` | Open quickfix window |
| `:cclose` | Close quickfix window |

---

## 5. LSP workflows

All LSP keymaps are buffer-local (only active when a server is attached).

### Navigation
| Key | Action |
|-----|--------|
| `gd` | Definitions (fzf) |
| `gD` | Declarations (fzf) |
| `gr` | References (fzf) |
| `gi` | Implementations (fzf) |
| `gt` | Type definitions (fzf) |
| `grt` | Type definition (built-in, 0.12 default) |
| `gS` | Document symbols (fzf) |
| `<leader>ws` | Workspace symbols (fzf) |
| `gO` | Document symbol outline (built-in) |

### Info / actions
| Key | Action |
|-----|--------|
| `K` | Hover docs |
| `grn` | Rename (0.11 built-in default) |
| `gra` | Code action (0.11 built-in default) |
| `grx` | Run code lens (0.12 built-in default) |
| `<leader>lr` | Restart LSP |

> Built-in defaults `grn`/`gra`/`grr`/`gri`/`grt`/`grx` use `vim.ui.select`
> which is taken over by fzf-lua when fzf is loaded — so you get fzf pickers
> for them automatically.

### Diagnostics
| Key | Action |
|-----|--------|
| `[d` / `]d` | Prev / next diagnostic (built-in) |
| `ge` | Workspace diagnostics (fzf) |
| `gE` | Document diagnostics (fzf) |
| `<leader>gd` | Document diagnostics (fzf) |
| `<leader>gw` | Workspace diagnostics (fzf) |
| `<leader>gW` | Workspace pull diagnostics |

> This config shows multi-line diagnostics via `virtual_lines` on the current
> line only — cleaner than stacked virtual text.

### Inlay hints & codelens
Inlay hints and codelens auto-enable on LSP attach — no keybind needed.
Use `grx` to run a codelens at the cursor.

---

## 6. Git workflows

### Gitsigns (buffer-local, activates on file open)
| Key | Action |
|-----|--------|
| `gn` / `gp` | Next / prev hunk |
| `gs` | Stage hunk |
| `gu` | Undo stage hunk |
| `gb` | Blame line |
| `gB` | Blame file |
| `<leader>gp` | Preview hunk |
| `<leader>gr` | Reset hunk |
| `gx` | Toggle deleted lines visible |

### Git pickers (fzf-lua)
| Key | Action |
|-----|--------|
| `<leader>gc` | Git commits |
| `<leader>gb` | Git branches |
| `<leader>gs` | Git stash |

### Lazygit & Diffview
| Key | Action |
|-----|--------|
| `;c` | Open LazyGit |
| `<leader>vd` | DiffviewOpen |
| `<leader>vh` | File history (current file) |
| `<leader>vb` | Branch history |
| `<leader>vc` | DiffviewClose |

---

## 7. Debugging (nvim-dap)

### Control
| Key | Action |
|-----|--------|
| `;d` | Continue (start session) |
| `;b` | Toggle breakpoint |
| `;o` | Step over |
| `;i` | Step into |
| `;t` | Terminate session |
| `<leader>d` | Dap commands picker (fzf) |

### During an active session (dap-ui attached)
| Key | Action |
|-----|--------|
| `<Down>` | Step over |
| `<Right>` | Step into |
| `<Left>` | Step out |
| `<Up>` | Restart frame |

Launch configs come from `.vscode/launch.json` automatically (Nvim 0.12
handles JSONC). Falls back to hand-written JS/TS configs when there's no
launch.json.

---

## 8. Folding (indent-based)

| Key | Action |
|-----|--------|
| `za` | Toggle fold at cursor |
| `zo` / `zc` | Open / close fold |
| `zO` / `zC` | Open / close recursively |
| `zM` / `zR` | Close / open all folds |
| `zj` / `zk` | Next / prev fold |
| `zm` / `zr` | One level more / less folded |

Folds follow indent level; everything starts open (`foldlevelstart=99`).

---

## 9. Windows, buffers, tabs

### Windows
| Key | Action |
|-----|--------|
| `<C-w>h/j/k/l` | Move between splits |
| `<C-w>s` / `<C-w>v` | Horizontal / vertical split |
| `<C-w>q` | Close split |
| `<C-w>=` | Balance split sizes |
| `<C-w>o` | Close all others |
| `<C-w>_` / `<C-w>|` | Max height / width |

### Buffers
| Key | Action |
|-----|--------|
| `<C-s>` | Save buffer (normal & insert) |
| `<BS>` | Alternate buffer (`:e #`) |
| `:bd` | Delete buffer |

---

## 10. Completion (blink.cmp, inside the menu)

| Key | Action |
|-----|--------|
| `<CR>` | Accept selection |
| `<Tab>` / `<S-Tab>` | Snippet forward / back |
| `<Up>` / `<Down>` | Select prev / next |
| `<C-p>` / `<C-n>` | Select prev / next |
| `<C-k>` | Toggle signature help |
| `<C-b>` / `<C-f>` | Scroll docs |
| `<C-e>` | Hide menu |

---

## 11. Misc workflows

### Todo comments (TODO / FIX / …)
| Key | Action |
|-----|--------|
| `]t` / `[t` | Next / prev TODO |
| `<leader>tt` | Fuzzy-find all TODOs |
| `<leader>tf` | Fuzzy-find TODOs & FIXes |

### Search & replace (grug-far)
| Key | Action |
|-----|--------|
| `<leader>sr` | Open grug-far (n/v) |

### Terminal (toggleterm)
| Key | Action |
|-----|--------|
| `<C-n>` | Toggle floating terminal |

### Diagnostics in cmdline
- `:messages` — show message history
- `:checkhealth` — run health checks (try `:checkhealth vim.lsp`)

---

## 12. Defaults that pay off if you remember them

Underused Vim defaults worth drilling:

| Key | Action |
|-----|--------|
| `.` | Repeat last change |
| `@:` | Repeat last ex command |
| `q{c}` / `q` | Record macro / stop |
| `@{c}` / `@@` | Play macro / replay |
| `gv` | Re-select last visual range |
| `gi` (insert mode) | Resume at last insert position (overridden by LSP gi) |
| `g;` / `g,` | Changelist back / forward |
| `<C-a>` / `<C-x>` | Increment / decrement number |
| `g<C-a>` / `g<C-x>` | Sequential increment in visual |
| `ga` | Show char info (unicode point) |
| `gq{motion}` | Format motion |
| `gw{motion}` | Format w/o moving cursor |
| `gf` | Go to file under cursor |
| `gx` | Open URL / documentLink (overridden → gitsigns toggle_deleted here) |
| `guu` / `gUU` | Lowercase / uppercase line |
| `J` | Join lines |
| `&` | Repeat last `:s` |
| `ZZ` / `ZQ` | Save+quit / quit no save |

---

## 13. Conflicts with defaults this config opts into

Worth knowing what you **lose** by using this config:

| Default key | What it normally did | Now |
|-------------|---------------------|-----|
| `s` | Substitute char | Flash jump |
| `r` (op-pending) | Replace char in op | Flash remote (edge case) |
| `gr` | Virtual replace | LSP references via fzf |
| `gi` | Resume last insert | LSP implementations via fzf |
| `gx` | Open URL | Gitsigns toggle deleted |

Recovery if you need the original: `cl` for `s`, `cc` for `S`, `<C-o>` to
jump back to insert, `:browse start {url}` for URL open.

---

## Practice plan

1. **Week 1** — sections 1, 2, 3. Drill motions + text objects until operators feel natural.
2. **Week 2** — section 4. Internalize flash (`s{char}{char}` for any jump). Stop using `/`.
3. **Week 3** — section 5 (LSP). Rename (`grn`), code action (`gra`), references (`gr`), hover (`K`), hunk review (`gn`, `gp`, `gs`).
4. **Week 4** — section 6 (git) + section 8 (folds). Stage hunks from nvim instead of terminal.
5. **Ongoing** — section 7 when debugging, section 12 for the deep cuts.
