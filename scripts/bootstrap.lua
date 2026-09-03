-- Headless provisioning for this Neovim config.
--
-- Run through scripts/install-deps.sh, or directly:
--   nvim --headless -c "lua dofile('scripts/bootstrap.lua')"
--
-- Everything Neovim installs at startup (vim.pack clones, lazy.nvim installs,
-- mason tools, tree-sitter parsers) is asynchronous, so a plain `nvim
-- --headless +qa` exits mid-install and leaves the machine half-provisioned.
-- This script drives each of those to completion, verifies the result on disk,
-- and exits non-zero if anything is still missing.
--
-- It must be sourced during startup (via -c) so its MasonToolsUpdateCompleted
-- autocmd is registered before mason-tool-installer's deferred run fires.

local deps = require("config.deps")

local MASON_TIMEOUT_MS = 15 * 60 * 1000
local PARSER_TIMEOUT_MS = 5 * 60 * 1000
local POLL_MS = 200

local failures = {}

local function log(fmt, ...)
  io.stdout:write(string.format(fmt, ...) .. "\n")
  io.stdout:flush()
end

local function fail(fmt, ...)
  local msg = string.format(fmt, ...)
  table.insert(failures, msg)
  log("  ✗ %s", msg)
end

local function section(name)
  log("\n==> %s", name)
end

-- ─── mason ───────────────────────────────────────────────────────────────────
-- Registered first, before anything blocks, so the startup-triggered run is
-- caught rather than raced.
local mason_done = false
vim.api.nvim_create_autocmd("User", {
  pattern = "MasonToolsUpdateCompleted",
  once = true,
  callback = function()
    mason_done = true
  end,
})

-- ─── binaries ────────────────────────────────────────────────────────────────
local function check_binaries()
  section("External binaries")
  for _, bin in ipairs(deps.binaries) do
    if vim.fn.executable(bin.cmd) == 1 then
      log("  ✓ %s", bin.cmd)
    elseif bin.required then
      fail("%s is missing (%s)", bin.cmd, bin.why)
    else
      log("  ! %s is missing (%s)", bin.cmd, bin.why)
    end
  end
end

-- ─── lazy.nvim ───────────────────────────────────────────────────────────────
local function install_lazy_plugins()
  section("lazy.nvim plugins")
  local lazy = require("lazy")
  -- install() clones anything missing and runs its build hook; wait = true
  -- blocks until the whole task queue drains.
  lazy.install({ wait = true, show = false })

  for _, plugin in pairs(lazy.plugins()) do
    if not plugin._.installed then
      fail("plugin %s failed to install", plugin.name)
    end
  end
  log("  ✓ %d plugins present", #lazy.plugins())
end

-- ─── magenta.nvim ────────────────────────────────────────────────────────────
-- Its build hook is `npm run build`, which needs node on Neovim's PATH. When
-- Neovim is launched outside a login shell (nvm not sourced) the hook fails
-- silently and the plugin falls back to source mode, which then dies on a
-- missing @magenta/core. Build it here where the shell environment is known.
local function build_magenta()
  section("magenta.nvim bundle")
  local root = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "magenta.nvim")
  if not vim.uv.fs_stat(root) then
    log("  ! magenta.nvim is not installed, skipping")
    return
  end
  if vim.uv.fs_stat(vim.fs.joinpath(root, "dist", "magenta.mjs")) then
    log("  ✓ dist/magenta.mjs already built")
    return
  end
  if vim.fn.executable("npm") == 0 then
    fail("npm is missing, cannot build magenta.nvim")
    return
  end

  log("  … running npm run build (this takes a minute)")
  local res = vim.system({ "npm", "run", "build" }, { cwd = root, text = true }):wait(10 * 60 * 1000)
  if res.code ~= 0 or not vim.uv.fs_stat(vim.fs.joinpath(root, "dist", "magenta.mjs")) then
    fail("magenta.nvim build failed:\n%s", (res.stderr or ""):sub(-800))
    return
  end
  log("  ✓ dist/magenta.mjs built")
end

-- ─── tree-sitter parsers ─────────────────────────────────────────────────────
local function install_parsers()
  section("tree-sitter parsers")
  if vim.fn.executable("tree-sitter") == 0 then
    fail("tree-sitter CLI is missing, no parser can be built")
    return
  end

  local ok, installer = pcall(require, "tree-sitter-manager.installer")
  if not ok then
    fail("tree-sitter-manager is not installed")
    return
  end
  local util = require("tree-sitter-manager.util")

  -- pack.lua fires these asynchronously at startup; let those land first so we
  -- do not clone the same parser twice.
  for _, lang in ipairs(deps.treesitter) do
    vim.wait(PARSER_TIMEOUT_MS, function()
      return vim.uv.fs_stat(util.ppath(lang)) ~= nil
    end, POLL_MS)
  end

  -- Anything still missing gets one deterministic serial retry.
  for _, lang in ipairs(deps.treesitter) do
    if vim.uv.fs_stat(util.ppath(lang)) then
      log("  ✓ %s", lang)
    else
      log("  … installing %s", lang)
      local finished, succeeded = false, false
      installer.install(lang, function(result)
        succeeded, finished = result, true
      end)
      vim.wait(PARSER_TIMEOUT_MS, function()
        return finished
      end, POLL_MS)
      if succeeded and vim.uv.fs_stat(util.ppath(lang)) then
        log("  ✓ %s", lang)
      else
        fail("parser %s failed to build", lang)
      end
    end
  end
end

-- ─── mason tools ─────────────────────────────────────────────────────────────
local function install_mason_tools()
  section("mason tools")
  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    fail("mason-registry is not available")
    return
  end

  if not vim.wait(MASON_TIMEOUT_MS, function()
    return mason_done
  end, POLL_MS) then
    log("  ! mason-tool-installer did not report completion, verifying on disk")
  end

  for _, name in ipairs(deps.mason) do
    local got, pkg = pcall(registry.get_package, name)
    if not got then
      fail("unknown mason package: %s", name)
    elseif pkg:is_installed() then
      log("  ✓ %s", name)
    else
      log("  … installing %s", name)
      local finished = false
      local done = function()
        finished = true
      end
      -- mason v1 returns a handle to subscribe to; v2 takes a callback.
      local handle = pkg:install({}, done)
      if type(handle) == "table" and handle.once then
        handle:once("closed", done)
      end
      vim.wait(MASON_TIMEOUT_MS, function()
        return finished
      end, POLL_MS)
      if pkg:is_installed() then
        log("  ✓ %s", name)
      else
        fail("mason package %s failed to install", name)
      end
    end
  end
end

-- ─── run ─────────────────────────────────────────────────────────────────────
check_binaries()
install_lazy_plugins()
build_magenta()
install_parsers()
install_mason_tools()

section("Result")
if #failures > 0 then
  log("%d problem(s):", #failures)
  for _, msg in ipairs(failures) do
    log("  - %s", msg)
  end
  vim.cmd("cquit 1")
end
log("  ✓ everything installed")
vim.cmd("qall!")
