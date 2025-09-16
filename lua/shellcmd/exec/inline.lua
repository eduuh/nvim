local M = {}

function M.run(cell, callback)
	local shell = vim.fn.executable("zsh") == 1 and "zsh" or "bash"
	vim.system({ shell, "-c", cell.command }, { text = true }, function(obj)
		local result = {
			stdout = obj.stdout or "",
			stderr = obj.stderr or "",
			code = obj.code or -1,
		}
		vim.schedule(function()
			callback(result)
		end)
	end)
end

return M
