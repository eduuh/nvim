local M = {}

local function project()
	local file = vim.api.nvim_buf_get_name(0)
	local root = vim.fs.root(file, "package.json")
	if not root then
		error("No package.json found for " .. file)
	end
	local package = vim.json.decode(table.concat(vim.fn.readfile(vim.fs.joinpath(root, "package.json")), "\n"))
	return root, package.scripts or {}
end

function M.pick()
	local root, scripts = project()
	local names = vim.tbl_keys(scripts)
	table.sort(names)
	if #names == 0 then
		vim.notify("No package.json scripts found", vim.log.levels.INFO)
		return
	end

	local choices = vim.tbl_map(function(name)
		return ("%s  %s"):format(name, scripts[name])
	end, names)

	vim.ui.select(choices, { prompt = "Run package script" }, function(_, index)
		if not index then
			return
		end
		local args = require("config.js_package").script(root, names[index])
		require("lazy").load({ plugins = { "toggleterm.nvim" } })
		local Terminal = require("toggleterm.terminal").Terminal
		Terminal:new({
			cmd = table.concat(vim.tbl_map(vim.fn.shellescape, args), " "),
			dir = root,
			direction = "horizontal",
			close_on_exit = false,
			display_name = names[index],
		}):toggle()
	end)
end

return M
