return {
	"ibhagwan/fzf-lua",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"junegunn/fzf",
		"sharkdp/fd",
	},
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup()

		vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>fw", fzf.live_grep, { desc = "Live Grep" })
		vim.keymap.set("n", "<leader>fr", fzf.registers, { desc = "Registers" })
		vim.keymap.set("n", "<leader>fs", fzf.treesitter, { desc = "Treesitter Symbols" })
		vim.keymap.set("n", "<leader>oq", fzf.quickfix, { desc = "Quickfix List" })
		vim.keymap.set("n", "gr", fzf.lsp_references, { desc = "LSP References" })
		vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "LSP Definitions" })
		vim.keymap.set("n", "gi", fzf.lsp_implementations, { desc = "LSP Implementations" })
		vim.keymap.set("n", "<leader>ca", fzf.lsp_code_actions, { desc = "LSP Code Actions" })
		vim.keymap.set("n", "[d", fzf.lsp_document_diagnostics, { desc = "Previous Diagnostic" })
		vim.keymap.set("n", "]d", fzf.lsp_document_diagnostics, { desc = "Next Diagnostic" })
		vim.keymap.set("n", "<leader>fd", fzf.lsp_workspace_diagnostics, { desc = "Workspace Diagnostics" })
	end,
}
