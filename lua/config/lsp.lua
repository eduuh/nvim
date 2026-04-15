-- LSP wiring for Nvim 0.12's native vim.lsp.config / vim.lsp.enable API.
-- This file is required from the nvim-lspconfig plugin spec (lua/plugins/lsp.lua)
-- once lspconfig is loaded, because it depends on lspconfig shipping per-server
-- config files under its runtime lsp/ directory.

local has_blink, blink = pcall(require, "blink.cmp")

vim.lsp.config("*", {
  capabilities = has_blink and blink.get_lsp_capabilities()
    or vim.lsp.protocol.make_client_capabilities(),
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      diagnostics = { globals = { "vim" } },
    },
  },
})

-- Servers managed natively (rust_analyzer → rustaceanvim, ts_ls → typescript-tools).
vim.lsp.enable({ "lua_ls", "cssls", "bashls", "marksman" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/codeLens") then
      vim.lsp.codelens.enable(true, { bufnr = args.buf })
    end

    local fzf = require("fzf-lua")
    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or "n", lhs, rhs, { buffer = args.buf, desc = desc })
    end

    map("<leader>lr", "<cmd>LspRestart<CR>", "LSP: restart")
    map("<leader>gW", vim.lsp.buf.workspace_diagnostics, "LSP: workspace pull diagnostics")

    map("gr", fzf.lsp_references, "LSP: references")
    map("gd", fzf.lsp_definitions, "LSP: definitions")
    map("gD", fzf.lsp_declarations, "LSP: declarations")
    map("gt", fzf.lsp_typedefs, "LSP: type definitions")
    map("gi", fzf.lsp_implementations, "LSP: implementations")
    map("gS", fzf.lsp_document_symbols, "LSP: document symbols")
    map("<leader>ws", fzf.lsp_workspace_symbols, "LSP: workspace symbols")

    map("ge", fzf.lsp_workspace_diagnostics, "LSP: workspace diagnostics")
    map("gE", fzf.lsp_document_diagnostics, "LSP: document diagnostics")
    map("<leader>gd", fzf.lsp_document_diagnostics, "LSP: document diagnostics")
    map("<leader>gw", fzf.lsp_workspace_diagnostics, "LSP: workspace diagnostics")
  end,
})
