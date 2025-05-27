local ensure_installed = {
  "cssls",
  "lua_ls",
  "rust_analyzer",
  "ts_ls",
  "bashls",
  "marksman",
}

return {
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = ensure_installed,
        auto_update = false,
        run_on_start = true,
        start_delay = 0,
        debounce_hours = 5,
        handlers = {
          function(server)
            local lspconfig = require("lspconfig")
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            lspconfig[server].setup({
              capabilities = capabilities,
            })
          end,
        },
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {},
    },
    config = function() end,
  },
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local mason = require("mason")

      local mason_tool_installer = require("mason-tool-installer")
      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      mason_tool_installer.setup({
        ensure_installed = {
          "prettier",
          "stylua",
          "eslint_d",
          "vim-language-server",
          "prettierd",
          "clang-format",
          "js-debug-adapter",
          "chrome-debug-adapter",
          "codelldb",
          "cpptools",
        },
      })
    end,
  },
}
