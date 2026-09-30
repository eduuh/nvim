-- tsgo: the native (Go) TypeScript language server shipped as @typescript/native.
--
-- Why this exists: the JS tsserver walks the whole project-reference graph before
-- answering anything. In a monorepo whose tsconfig references fan out across
-- thousands of packages (1JS/midgard: 505 direct references, 4200+ tsconfigs in
-- the transitive closure), it parses configs for 20+ minutes and never returns a
-- hover. tsgo answers the same hover in well under a minute and is instant after.
--
-- So: when a workspace ships @typescript/native, prefer its tsgo binary and leave
-- typescript-tools (and its two tsserver processes) out of that workspace entirely.

local M = {}

local function platform_package()
  local uname = vim.uv.os_uname()
  local os_name = ({ Linux = "linux", Darwin = "darwin", Windows_NT = "win32" })[uname.sysname]
  local arch = ({ x86_64 = "x64", aarch64 = "arm64", arm64 = "arm64" })[uname.machine]
  if not os_name or not arch then
    return nil
  end
  return ("typescript-%s-%s"):format(os_name, arch)
end

--- Locate the tsgo executable a workspace provides, or nil.
---@param start string? directory or file path to search upwards from
---@return string? path to the executable
function M.find(start)
  local pkg = platform_package()
  if not pkg then
    return nil
  end

  local found = vim.fs.find(function(name, path)
    return name == "native" and path:match("node_modules/@typescript$") ~= nil
  end, { path = start or vim.fn.getcwd(), upward = true, type = "link", limit = 1 })

  -- vim.fs.find's `type` filter misses a real directory; retry without it.
  if #found == 0 then
    found = vim.fs.find("node_modules/@typescript/native", {
      path = start or vim.fn.getcwd(),
      upward = true,
      limit = 1,
    })
  end
  if #found == 0 then
    return nil
  end

  local real = vim.uv.fs_realpath(found[1])
  if not real then
    return nil
  end

  -- The platform package sits beside @typescript/native in the same
  -- node_modules/@typescript directory.
  local exe = vim.fs.joinpath(vim.fs.dirname(real), pkg, "lib", "tsc")
  local stat = vim.uv.fs_stat(exe)
  if stat and stat.type == "file" then
    return exe
  end
  return nil
end

--- Register tsgo as an LSP server when the workspace provides it.
--- Returns the executable path if it was registered.
function M.setup()
  local exe = M.find()
  if not exe then
    return nil
  end

  -- Registered as "tsc", not "tsgo": nvim-lspconfig ships a server named tsgo
  -- that it has deprecated in favour of tsc, and reusing that name makes it
  -- print a deprecation warning on every start.
  vim.lsp.config("tsc", {
    cmd = { exe, "--lsp", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
  })
  vim.lsp.enable("tsc")
  return exe
end

return M
