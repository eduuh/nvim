local M = {}
local js_package = require("config.js_package")

function M.project()
	local root = js_package.root(vim.api.nvim_buf_get_name(0))
	local package = vim.json.decode(table.concat(vim.fn.readfile(vim.fs.joinpath(root, "package.json")), "\n"))
	return root, package.scripts or {}
end

function M.select(prompt, callback)
	local root, scripts = M.project()
	local names = vim.tbl_keys(scripts)
	table.sort(names)
	if #names == 0 then
		vim.notify("No package.json scripts found", vim.log.levels.INFO)
		return
	end

	local choices = vim.tbl_map(function(name)
		return ("%s  %s"):format(name, scripts[name])
	end, names)

	vim.ui.select(choices, { prompt = prompt }, function(_, index)
		if not index then
			return
		end
		callback(root, names[index])
	end)
end

function M.pick()
	M.select("Run package script", function(root, name)
		local args = js_package.script(root, name)
		require("lazy").load({ plugins = { "toggleterm.nvim" } })
		local Terminal = require("toggleterm.terminal").Terminal
		Terminal:new({
			cmd = table.concat(vim.tbl_map(vim.fn.shellescape, args), " "),
			dir = root,
			direction = "horizontal",
			close_on_exit = false,
			display_name = name,
		}):toggle()
	end)
end

function M.debug_pick()
	M.select("Debug package script", function(root, name)
		local ok, config = pcall(require("config.dap.jsandts").package_script_config, root, name)
		if not ok then
			vim.notify(config, vim.log.levels.ERROR)
			return
		end
		require("lazy").load({ plugins = { "nvim-dap" } })
		require("dap").run(config)
	end)
end

return M
