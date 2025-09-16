local core = require("shellcmd.core")

local M = {}

function M.setup()
	vim.api.nvim_create_user_command("ShellRunCell", function()
		core.run_cell()
	end, {})

	vim.api.nvim_create_user_command("ShellOutputOpen", function()
		core.open_output()
	end, {})
end

return M
