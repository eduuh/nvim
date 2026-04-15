# Keybindings

Leader = `Space` · LocalLeader = `\`

---

## Global

| Key | Mode | Action |
|-----|------|--------|
| `<C-s>` | n, i | Save file |
| `<BS>` | n, v | Alternate buffer |
| `;n` | n | Next quickfix |
| `;p` | n | Prev quickfix |

---

## Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<C-n>` | n | Toggle main terminal (tmux `main` session) |
| `<leader>cy` | n | Toggle Claude Code yolo terminal (tmux `claude` session) |
| `<leader>tu` | n, t | Unlock outer tmux (emergency re-enable) |
| `<Esc><Esc>` | t | Exit terminal insert mode |

> Inner tmux prefix: `Ctrl-a` · Outer tmux is locked while any terminal is open

---

## Find (fzf-lua)

| Key | Mode | Action |
|-----|------|--------|
| `<C-p>` / `<leader>ff` | n | Find files |
| `<leader>fw` | n | Live grep |
| `<leader>fo` | n | Recent files |
| `<leader>fr` | n | Registers |
| `<leader>wd` | n | Workspace diagnostics |
| `<leader>ql` | n | Quickfix list |
| `<leader>qs` | n | Quickfix stack |

**Inside fzf picker:**

| Key | Action |
|-----|--------|
| `Enter` | Edit or open quickfix |
| `Ctrl-s` | Open in horizontal split |
| `Ctrl-v` | Open in vertical split |
| `Ctrl-h` | Toggle hidden files |
| `Ctrl-q` | Select all → quickfix |

---

## LSP _(buffer-local, active when LSP is attached)_

| Key | Action |
|-----|--------|
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `[d` / `]d` | Prev / next diagnostic |
| `<leader>lr` | Restart LSP |
| `gd` | Definitions |
| `gD` | Declarations |
| `gr` | References |
| `gt` | Type definitions |
| `gi` | Implementations |
| `gS` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `ge` | Workspace diagnostics |
| `gE` | Document diagnostics |
| `<leader>gd` | Document diagnostics |
| `<leader>gw` | Workspace diagnostics |
| `<leader>ca` | Code actions (n, v) |

---

## Git

| Key | Mode | Action |
|-----|------|--------|
| `;c` | n | Open LazyGit |
| `<leader>gc` | n | Git commits |
| `<leader>gb` | n | Git branches |
| `<leader>gs` | n | Git stash |
| `gb` | n | Blame line |
| `gB` | n | Blame (full file) |
| `gn` | n | Next hunk |
| `gp` | n | Prev hunk |
| `<leader>gp` | n | Preview hunk |
| `gs` | n | Stage hunk |
| `gu` | n | Undo stage hunk |
| `gx` | n | Toggle deleted lines |
| `<leader>gr` | n | Reset hunk |
| `<leader>vd` | n | Diffview open |
| `<leader>vh` | n | Diffview file history |
| `<leader>vb` | n | Diffview branch history |
| `<leader>vc` | n | Diffview close |

---

## DAP (Debugger)

| Key | Action |
|-----|--------|
| `;b` | Toggle breakpoint |
| `;d` | Run / Continue |
| `;o` | Step over |
| `;i` | Step into |
| `;t` | Terminate session |
| `<leader>d` | DAP commands (fzf) |

**While session is active (DAP UI open):**

| Key | Action |
|-----|--------|
| `<Down>` | Step over |
| `<Right>` | Step into |
| `<Left>` | Step out |
| `<Up>` | Restart frame |

---

## Trouble

| Key | Action |
|-----|--------|
| `<leader>xx` | Workspace diagnostics |
| `<leader>xd` | Document diagnostics |
| `<leader>xs` | Symbols |
| `<leader>xq` | Quickfix |
| `<leader>xl` | Loclist |

---

## TODO Comments

| Key | Action |
|-----|--------|
| `]t` / `[t` | Next / prev TODO |
| `<leader>tt` | Search all TODOs |
| `<leader>tf` | TODOs & FIXes only |

---

## Navigation

| Key | Action |
|-----|--------|
| `;;` | Oil file explorer (current dir) |
| `<leader>uu` | Toggle undo tree |
| `<leader>sr` | Search & replace (grug-far, n/v) |

---

## Flash (motion)

| Key | Mode | Action |
|-----|------|--------|
| `s` | n, x, o | Flash jump |
| `S` | n, x, o | Flash treesitter |
| `r` | o | Remote flash |
| `R` | o, x | Treesitter search |
| `<C-s>` | c | Toggle flash in `/` search |

---

## AI

### CodeCompanion

| Key | Mode | Action |
|-----|------|--------|
| `<C-a>` | n, v | Action palette |
| `<leader>a` | n, v | Toggle chat |
| `<LocalLeader>a` | v | Add selection to chat |
| `cc` | cmd | Abbreviation for `:CodeCompanion` |

**Inside chat buffer:**

| Key | Mode | Action |
|-----|------|--------|
| `<C-CR>` / `<C-s>` | i | Send message |
| `<C-x>` | i | Completion |
| `<C-b>` | i | `/buffer` slash command |
| `<C-f>` | i | `/fetch` slash command |
| `gh` | n | Browse history |
| `sc` | n | Save chat |

### Copilot Panel

| Key | Action |
|-----|--------|
| `[[` / `]]` | Jump prev / next suggestion |
| `<CR>` | Accept suggestion |
| `gr` | Refresh |
| `<M-CR>` | Open panel |

---

## REST (Kulala)

| Key | Action |
|-----|--------|
| `<leader>rr` | Run request |
| `<leader>rn` / `<leader>rp` | Jump next / prev request |
| `<leader>ri` | Inspect request |
| `<leader>rt` | Toggle response view |
| `<leader>rc` | Copy as curl |

---

## Competitive Programming _(cpp, c, rust, ts, js)_

| Key | Action |
|-----|--------|
| `;r` | Run test cases |
| `;a` | Add test case |
