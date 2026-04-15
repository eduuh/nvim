# Keybinding Practice Plan

Work through one stage per session. Don't move on until the keys feel automatic.

---

## Stage 1 — Survival (do this every day until muscle memory)

These are the keys you'll use in every single session.

**Drills:**
1. Open any file. Save it with `<C-s>`. Do it 20 times.
2. Open two files. Switch between them with `<BS>`. Don't use `:b`.
3. Navigate quickfix: `;n` / `;p`. Run a grep, open the qf list, walk through results.

| Key | Action |
|-----|--------|
| `<C-s>` | Save |
| `<BS>` | Alternate buffer |
| `;n` / `;p` | Next / prev quickfix |
| `<C-n>` | Open terminal |
| `<Esc><Esc>` | Exit terminal mode |

---

## Stage 2 — Finding Things (fzf-lua)

**Drills:**
1. Open a project. Find a file with `<C-p>`. Open it with Enter. Repeat with Ctrl-s and Ctrl-v.
2. Search for a word across the codebase with `<leader>fw`. Send results to quickfix with `Ctrl-q`.
3. Open recent files with `<leader>fo` without typing the name.
4. Navigate to a file, make an error, find it with `<leader>wd`.

| Key | Action |
|-----|--------|
| `<C-p>` | Find files |
| `<leader>fw` | Live grep |
| `<leader>fo` | Recent files |
| `<leader>wd` | Workspace diagnostics |
| `Ctrl-q` _(in picker)_ | Send all to quickfix |

---

## Stage 3 — Navigation (Flash + Oil)

**Drills:**
1. Open a long file. Press `s` and jump to any word on screen. Do not use `/`.
2. Press `S` to select a treesitter node with Flash. Use it in operator pending mode (`ds`, `ys`).
3. Open the file explorer with `;;`. Navigate to a sibling directory. Open a file.

| Key | Action |
|-----|--------|
| `s` | Flash jump |
| `S` | Flash treesitter |
| `;;` | Oil file explorer |

---

## Stage 4 — LSP (the big one)

Open a real codebase with an LSP attached for all of these.

**Drills:**
1. Put cursor on a function call. Press `gd` to go to definition. Come back with `<C-o>`.
2. Press `K` on a symbol. Read the docs without touching the mouse.
3. Press `gr` on a function. Walk through references with `<C-n>` / `<C-p>` in the fzf picker.
4. Find a diagnostic with `]d`. Fix it with `<leader>ca`. Rename a variable across the file with `<leader>rn`.
5. Press `gS` to see all document symbols. Jump to one.

| Key | Action |
|-----|--------|
| `K` | Hover docs |
| `gd` | Go to definition |
| `gr` | References |
| `gt` | Type definition |
| `gi` | Implementations |
| `gS` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `]d` / `[d` | Next / prev diagnostic |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename |

---

## Stage 5 — Git

Open any git repo for these.

**Drills:**
1. Make a change. Stage it with `gs`. Undo with `gu`. Reset it with `<leader>gr`.
2. Jump between hunks with `gn` and `gp`. Preview each with `<leader>gp`.
3. Press `gb` on a line to see who wrote it.
4. Open `<leader>gc` and browse commit history. Open `<leader>gb` and switch branches.
5. Open `;c` (LazyGit) and make a commit entirely from there.
6. Open `<leader>vd` for a diff. Browse file history with `<leader>vh`.

| Key | Action |
|-----|--------|
| `gs` / `gu` | Stage / unstage hunk |
| `gn` / `gp` | Next / prev hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gr` | Reset hunk |
| `gb` / `gB` | Blame line / full |
| `<leader>gc` | Commits |
| `<leader>gb` | Branches |
| `;c` | LazyGit |
| `<leader>vd` | Diffview |

---

## Stage 6 — AI (CodeCompanion + Claude)

**Drills:**
1. Open `<leader>cy`. Verify Claude Code is running in yolo mode. Ask it something.
2. Close the float. Notice outer tmux unlocks. Reopen. Practice `<Esc><Esc>` to get back to Neovim.
3. Select a block of code in visual mode. Press `<leader>a` to add it to a chat.
4. Open a chat with `<leader>a`. Send a message with `<C-s>`. Browse history with `gh`.
5. Press `<C-a>` to open the action palette and explore available actions.

| Key | Action |
|-----|--------|
| `<leader>cy` | Claude Code (yolo) |
| `<leader>a` | Toggle chat |
| `<C-a>` | Action palette |
| `<LocalLeader>a` | Add selection to chat |
| `<C-s>` _(chat)_ | Send message |
| `gh` _(chat)_ | History |

---

## Stage 7 — Debugging (DAP)

Use a real project with a working debug config for these.

**Drills:**
1. Set a breakpoint with `;b` on a line. Run with `;d`. Verify it stops.
2. Step through code: `;o` over, `;i` into. Watch variables in DAP UI.
3. While DAP UI is open, use arrow keys: `<Down>` step over, `<Right>` into, `<Left>` out.
4. Terminate with `;t`. Verify arrow keys go back to normal navigation.
5. Use `<leader>d` to browse all DAP commands.

| Key | Action |
|-----|--------|
| `;b` | Toggle breakpoint |
| `;d` | Run / continue |
| `;o` / `;i` | Step over / into |
| `;t` | Terminate |
| `<Down/Right/Left/Up>` | Step controls (UI active) |

---

## Stage 8 — Everything Else

Pick these up opportunistically as situations arise.

| Key | Action | When to use |
|-----|--------|-------------|
| `<leader>sr` | Search & replace | Renaming across files |
| `<leader>uu` | Undo tree | You made too many undos |
| `<leader>xx` | Trouble diagnostics | Reviewing all errors at once |
| `<leader>tt` | TODO search | Start of a work session |
| `]t` / `[t` | Jump TODOs | Navigating your own notes |
| `;r` / `;a` | Competitest | Competitive programming |
| `<leader>rr` | Run HTTP request | Working on REST APIs |
| `<leader>tu` | Unlock outer tmux | Something went wrong |

---

## Daily Warmup (2 minutes)

Run this at the start of every session until everything is automatic:

1. `<C-p>` → find a file → open with `Ctrl-v`
2. `<leader>fw` → search for a symbol → `Ctrl-q` → `;n` `;n` `;n`
3. `gd` on something → `K` → `gr` → `<C-o>` back
4. `gn` → `gs` → `gu`
5. `<leader>cy` → say hi to Claude → `<Esc><Esc>`
