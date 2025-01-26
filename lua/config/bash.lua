vim.api.nvim_create_autocmd("FileType", {
	pattern = "sh",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "sh", ":!chmod +x % && source %<CR>", { noremap = true, silent = true })
	end,
})
