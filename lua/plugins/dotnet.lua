return {
	{
		"GustavEikaas/easy-dotnet.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			local logPath = vim.fn.stdpath("data") .. "/easy-dotnet/build.log"
			local dotnet = require("easy-dotnet")
			local cmp = require("cmp")
			cmp.register_source("easy-dotnet", require("easy-dotnet").package_completion_source)

			dotnet.setup({
				terminal = function(path, action)
					local commands = {
						run = function()
							return "dotnet run --project " .. path
						end,
						test = function()
							return "dotnet test " .. path
						end,
						restore = function()
							return "dotnet restore --configfile " .. os.getenv("NUGET_CONFIG") .. " " .. path
						end,
						build = function()
							return "dotnet build -c Debug" .. path .. " /flp:v=q /flp:logfile=" .. logPath
						end,
					}

					local function filter_warnings(line)
						if not line:find("warning") then
							return line:match("^(.+)%((%d+),(%d+)%)%: (.+)$")
						end
					end

					local overseer_components = {
						{ "on_complete_dispose", timeout = 30 },
						"default",
						{ "unique", replace = true },
						{
							"on_output_parse",
							parser = {
								diagnostics = {
									{ "extract", filter_warnings, "filename", "lnum", "col", "text" },
								},
							},
						},
						{
							"on_result_diagnostics_quickfix",
							open = true,
							close = true,
						},
					}

					if action == "run" or action == "test" then
						table.insert(overseer_components, { "restart_on_save", paths = { vim.fn.getcwd() } })
					end

					local command = commands[action]()
					local task = require("overseer").new_task({
						strategy = {
							"toggleterm",
							use_shell = false,
							direction = "horizontal",
							open_on_start = false,
						},
						name = action,
						cmd = command,
						cwd = vim.fn.getcwd(),
						components = overseer_components,
					})
					task:start()
				end,
			})
		end,
	},
}
