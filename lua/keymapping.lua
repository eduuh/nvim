local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set({ "n", "v" }, "<BS>", "<C-^>", { desc = "Alternate File" })

keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save file and quit
keymap.set("n", "<Leader>w", ":update<Return>", opts)
keymap.set("n", "<Leader>q", ":quit<Return>", opts)
keymap.set("n", "<Leader>Q", ":qa<Return>", opts)

-- Split window
keymap.set("n", "<leader>h", ":split<Return>", opts)
keymap.set("n", "<leader>v", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-S-h>", "<C-w><")
keymap.set("n", "<C-S-l>", "<C-w>>")
keymap.set("n", "<C-S-k>", "<C-w>+")
keymap.set("n", "<C-S-j>", "<C-w>-")

-- Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

-- Remap the delete command to use a less-used register, for example, "q"
keymap.set("n", "d", '"qd', opts)
keymap.set("v", "d", '"qd', opts)

-- Remap delete line (dd) to also use the "q" register
keymap.set("n", "dd", '"qdd', opts)

-- Remap delete to the end of the line (D) to use the "q" register
keymap.set("n", "D", '"qD', opts)

-- Remap change (c) commands similarly to use the "q" register
keymap.set("n", "c", '"qc', opts)
keymap.set("v", "c", '"qc', opts)
keymap.set("n", "cc", '"qcc', opts)
keymap.set("n", "C", '"qC', opts)

LSP_MAPPINGS = function(bufnr)
	local map = vim.keymap.set

	local diagnostic_goto = function(next, severity)
		local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
		severity = severity and vim.diagnostic.severity[severity] or nil
		return function()
			go({ severity = severity })
		end
	end
	-- Mappings.
	local local_opts = { buffer = bufnr, noremap = true, silent = true }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, local_opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, local_opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, local_opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, local_opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, local_opts)
	vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, local_opts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, local_opts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, local_opts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, local_opts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, local_opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, local_opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, local_opts)
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, local_opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, local_opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, local_opts)

	map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
	map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
	map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
	map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
	map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
	map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
end

local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(_, bufnr)
	LSP_MAPPINGS(bufnr)
end)
