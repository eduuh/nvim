return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				c = { "clang-format" },
				cpp = { "clang-format" },
				cmake = { "cmake-format" },
				markdown = { "prettier" },
				yaml = { "prettier" },
				rust = { "rustfmt", lsp_format = "fallback" },
				html = { "prettier" },
				sh = { "shfmt" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		})
	end,
}
