vim.g.mapleader = " "
dofile("lua/config/keymaps.lua")

if vim.env.NVIM_QUIT_CASE then
	local marker = vim.env.NVIM_QUIT_MARKER
	if vim.env.NVIM_QUIT_CASE == "diffview" then
		vim.api.nvim_create_user_command("DiffviewClose", function()
			error("leader-q must not invoke DiffviewClose")
		end, {})
	end
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			vim.fn.writefile({ "nvim exited" }, marker, "a")
		end,
	})
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "unsaved first buffer" })
	vim.cmd("vnew")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "unsaved second buffer" })
	vim.cmd("tabnew")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "unsaved third buffer" })
	local mapping = vim.fn.maparg(" q", "n", false, true)
	assert(mapping.rhs == "<cmd>qa!<CR>", "leader-q must map directly to qa!")
	vim.api.nvim_feedkeys(" q", "xt", false)
	error("leader-q did not exit Neovim")
end

for _, case in ipairs({ "diffview", "no-plugin" }) do
	local marker = vim.fn.tempname()
	local result = vim.system({
		vim.v.progpath,
		"--headless",
		"-u",
		"NONE",
		"-l",
		"tests/quit.lua",
	}, {
		text = true,
		env = { NVIM_QUIT_CASE = case, NVIM_QUIT_MARKER = marker },
	}):wait(5000)
	assert(result.code == 0, result.stderr)
	assert(vim.deep_equal(vim.fn.readfile(marker), { "nvim exited" }), "Neovim did not exit")
	vim.fn.delete(marker)
end

print("QUIT_OK")
