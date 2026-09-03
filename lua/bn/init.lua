-- bn — the editor half of `bn edit`.
--
-- bn runs one nvim per worktree, started with `--listen <sock>`, and drives it from the outside:
-- `bn edit show/hide/toggle` moves the pane around in tmux, and `bn edit land` asks *this* module
-- to put the editor on the branch's diff with the agent terminal spawned.
--
-- The contract is a versioned table, not a list of `:` commands. That keeps Diffview and
-- toggleterm API details on this side — where they can actually be tested against the installed
-- plugins — and it is the only shape that can express idempotency, because only nvim can see its
-- own tabs and terminals. `land()` is called with the same spec file on both paths: a cold start
-- gets it via `nvim -c`, a running editor via `--remote-expr`, so the two are the same input.

local M = {}

local SPEC_V = 1
-- A pinned count so the agent terminal is a singleton per editor: `get(TERM_COUNT)` is how we
-- recognize "already spawned" rather than stacking a second one on every landing.
local TERM_COUNT = 99

local function bn_bin()
  return vim.env.HOME .. "/.config/bn/bn"
end

--- Fire-and-forget shell to bn. Never blocks the UI: bn may be doing tmux work that outlives the
--- keypress, and an editor that freezes while parking itself defeats the point.
local function bn(args)
  vim.system(vim.list_extend({ bn_bin() }, args), { text = true })
end

function M.sock()
  return vim.env.BN_EDIT_SOCK
end

function M.worktree()
  return vim.env.BN_EDIT_WT or vim.uv.cwd()
end

--- Re-listen on the derived socket if we are not already.
---
--- tmux-resurrect restores nvim panes (it is on resurrect's default restore list) but restores them
--- *without* `--listen`, so after a reboot bn would find a running editor it cannot talk to — and
--- would cheerfully split in a second one. Re-binding here closes that hole from the editor's side;
--- `bn edit reconcile` closes it from tmux's.
function M.ensure_server()
  local s = M.sock()
  if not s or s == "" then
    return
  end
  if vim.v.servername == s then
    return
  end
  pcall(vim.fn.serverstart, s)
end

-- ── the pieces a landing is made of ─────────────────────────────────────────────────────────

local function agent_terminal()
  local ok, tt = pcall(require, "toggleterm.terminal")
  if not ok then
    return nil, nil
  end
  -- include_hidden: ours is deliberately spawned hidden, and the default lookup skips those.
  return tt.get(TERM_COUNT, true), tt
end

--- Spawn (once) and show/hide the agent terminal.
local function ensure_term(spec)
  if spec.term == "off" then
    return false
  end
  local term, tt = agent_terminal()
  if not tt then
    return false
  end
  if not term then
    term = tt.Terminal:new({
      count = TERM_COUNT,
      cmd = spec.agent_cmd,
      dir = spec.worktree,
      direction = "horizontal",
      hidden = true,
      -- Never true for a bn agent terminal: it deletes the buffer the moment the process exits,
      -- destroying the agent's final output — exactly what `remain-on-exit on` exists to prevent
      -- on the tmux side.
      close_on_exit = false,
    })
    local ok = pcall(function()
      term:spawn()
    end)
    if not ok then
      return false
    end
  end
  if spec.term == "visible" then
    pcall(function()
      term:open()
    end)
  else
    pcall(function()
      term:close()
    end)
  end
  return true
end

--- Open the branch's diff, or focus the one that is already open.
local function ensure_diff(spec)
  if not spec.diff then
    return false
  end
  local rev = spec.base .. "...HEAD"
  local ok, lib = pcall(require, "diffview.lib")
  if ok and lib.views then
    for _, v in ipairs(lib.views) do
      if v.rev_arg == rev then
        -- Focus the existing tab. Landing twice must not stack a second identical view.
        pcall(function()
          v:open()
        end)
        return true
      end
    end
  end
  -- `-C` rather than `:cd`: Diffview resolves the repo from that path, so a landing fired while a
  -- floating terminal is focused still targets the worktree instead of wherever the buffer lives.
  vim.cmd(
    ("DiffviewOpen %s -C %s"):format(rev, vim.fn.fnameescape(spec.worktree))
  )
  return true
end

-- ── the entrypoint bn calls ─────────────────────────────────────────────────────────────────

--- Apply a landing spec. Returns a status table; bn reports `did`/`why` back to the caller.
function M.land(spec)
  if type(spec) ~= "table" then
    return { ok = false, why = "spec is not a table" }
  end
  if spec.v ~= SPEC_V then
    return { ok = false, why = ("unsupported spec version %s"):format(tostring(spec.v)) }
  end

  -- Idempotency lives here because only nvim can see its own tabs: same (base, diff, term) means
  -- there is nothing to do, and saying so is a success rather than a failure.
  local prev = vim.g.bn_landed
  if not spec.force and prev and prev.base == spec.base and prev.diff == spec.diff and prev.term == spec.term then
    return { ok = true, landed = false, why = "already", did = {} }
  end

  local did = {}
  if ensure_diff(spec) then
    table.insert(did, "diff")
  end
  if ensure_term(spec) then
    table.insert(did, "term")
  end
  for _, f in ipairs(spec.files or {}) do
    pcall(vim.cmd.edit, vim.fn.fnameescape(f))
  end

  vim.g.bn_landed = { base = spec.base, diff = spec.diff, term = spec.term, at = os.time() }
  return { ok = true, landed = true, did = did }
end

--- Read a spec from disk and apply it. The path form is what both the cold (`nvim -c`) and warm
--- (`--remote-expr`) paths use, so they read the same bytes.
function M.land_file(path)
  local fd = io.open(path, "r")
  if not fd then
    return { ok = false, why = "no spec at " .. tostring(path) }
  end
  local body = fd:read("*a")
  fd:close()
  local ok, spec = pcall(vim.json.decode, body)
  if not ok then
    return { ok = false, why = "spec is not valid json" }
  end
  return M.land(spec)
end

--- Give the screen back without leaving the editor.
---
--- On an `editor`-shaped window nvim *is* the window, so there is no guest pane for tmux to park —
--- `break-pane` on the only pane would strip the window of its identity. Hiding there means closing
--- the diff and letting the agent terminal have the height.
function M.hide()
  pcall(vim.cmd, "DiffviewClose")
  local term = agent_terminal()
  if term then
    pcall(function()
      term:open()
    end)
  end
  vim.g.bn_landed = nil
  return { ok = true }
end

--- Toggle the agent terminal in place.
function M.toggle()
  local term = agent_terminal()
  if term then
    pcall(function()
      term:toggle()
    end)
  end
  return { ok = true }
end

--- Park this editor pane in tmux's hold session. bn owns every tmux call; this just asks.
function M.park()
  bn({ "edit", "hide", "--path", M.worktree() })
end

--- Land this worktree on its diff, via bn (so the base is resolved the same way everywhere).
function M.relanded()
  bn({ "edit", "land", "--path", M.worktree() })
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("BnEditor", { clear = true }),
  callback = M.ensure_server,
})

return M
