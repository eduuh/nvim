return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "antosha417/nvim-lsp-file-operations", config = true },
      {
        "lvimuser/lsp-inlayhints.nvim",
        event = "VeryLazy",
        config = function()
          require("lsp-inlayhints").setup({
            inlay_hints = {
              parameter_hints = {
                show = true,
                prefix = "<- ",
                separator = ", ",
                remove_colon_start = false,
                remove_colon_end = true,
              },
              type_hints = {
                show = true,
                prefix = "",
                separator = ", ",
                remove_colon_start = false,
                remove_colon_end = true,
              },
              only_current_line = false,
              labels_separator = "  ",
              max_len_align = false,
              max_len_align_padding = 1,
              highlight = "LspInlayHint",
              priority = 0,
            },
            enabled_at_startup = true,
            debug_mode = false,
          })
        end,
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function()
          local map = require("config.utils").map
          local mapMany = require("config.utils").mapMany
          map("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename")
          map("n", "gr", "<cmd>lua require'fzf-lua'.lsp_references()<CR>")
          map("n", "gd", "<cmd>lua require'fzf-lua'.lsp_definitions()<CR>")
          map("n", "gD", "<cmd>lua require'fzf-lua'.lsp_declarations()<CR>")
          map("n", "gt", "<cmd>lua require'fzf-lua'.lsp_typedefs()<CR>")
          map("n", "gi", "<cmd>lua require'fzf-lua'.lsp_implementations()<CR>")
          map("n", "gs", "<cmd>lua require'fzf-lua'.lsp_workspace_symbols()<CR>")
          map("n", "gS", "<cmd>lua require'fzf-lua'.lsp_document_symbols()<CR>")
          map("n", "gS", "<cmd>lua require'fzf-lua'.lsp_document_diagnostics()<CR>")
          mapMany({ "n", "v" }, "<leader>ca", "<cmd>lua require'fzf-lua'.lsp_code_actions()<CR>")

          map("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor")

          map("n", "<leader>lr", ":LspRestart<CR>", "Restart LSP")
          map("n", "ge", "<cmd>lua require'fzf-lua'.lsp_workspace_diagnostics()<CR>", "Go to previous diagnostic")

          map("n", "gE", "<cmd>lua require'fzf-lua'.lsp_documents_diagnostics()<CR>", "Go to previous diagnostic")

          map("n", "[d", vim.diagnostic.goto_next, "Go to next diagnostic")
          map("n", "]d", vim.diagnostic.goto_prev, "Go to prev diagnostic")

          map("n", "<leader>dd", "<cmd>lua require'fzf-lua'.lsp_document_diagnostics()<CR>")
          map("n", "<leader>wd", "<cmd>lua require'fzf-lua'.lsp_workspace_diagnostics()<CR>")
        end,
      })
    end,
  },
}
