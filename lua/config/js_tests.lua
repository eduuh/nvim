local M = {}
local test_terminal
local watch_terminal
local js_package = require("config.js_package")

local function context()
	local file = vim.api.nvim_buf_get_name(0)
	local root = js_package.root(file)

	local package = vim.json.decode(table.concat(vim.fn.readfile(vim.fs.joinpath(root, "package.json")), "\n"))
	local dependencies = vim.tbl_extend("force", package.dependencies or {}, package.devDependencies or {})
	local runner = dependencies.vitest and "vitest" or dependencies.jest and "jest"
	if not runner then
		error("Neither Vitest nor Jest is installed in " .. root)
	end

	return {
		file = file,
		root = root,
		runner = runner,
	}
end

local function treesitter_test_name()
	local ok, node = pcall(vim.treesitter.get_node)
	if not ok or not node then
		return
	end
	while node do
		if node:type() == "call_expression" then
			local callable = node:field("function")[1]
			local arguments = node:field("arguments")[1]
			local name = callable and vim.treesitter.get_node_text(callable, 0) or ""
			if arguments and (name:match("^it[%._%w]*$") or name:match("^test[%._%w]*$")) then
				local argument = arguments:named_child(0)
				if argument and (argument:type() == "string" or argument:type() == "template_string") then
					return vim.treesitter.get_node_text(argument, 0):sub(2, -2)
				end
			end
		end
		node = node:parent()
	end
end

local function fallback_test_name()
	local cursor = vim.api.nvim_win_get_cursor(0)[1]
	local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, cursor, false), "\n")
	local nearest_start
	local nearest_name
	for _, base in ipairs({ "it", "test" }) do
		for _, quote in ipairs({ '"', "'", "`" }) do
			for _, suffix in ipairs({ "", "%.[%w_%.]+" }) do
				local pattern = "%f[%a]" .. base .. suffix .. "%s*%(%s*" .. quote .. "([^" .. quote .. "]+)"
				local offset = 1
				while true do
					local start, finish, name = text:find(pattern, offset)
					if not start then
						break
					end
					if not nearest_start or start > nearest_start then
						nearest_start = start
						nearest_name = name
					end
					offset = finish + 1
				end
			end
		end
	end
	if nearest_name then
		return nearest_name
	end
	error("No it() or test() found above the cursor")
end

function M.nearest_test_name()
	return treesitter_test_name() or fallback_test_name()
end

local regex_metacharacters = {
	["\\"] = true,
	["^"] = true,
	["$"] = true,
	["."] = true,
	["|"] = true,
	["?"] = true,
	["*"] = true,
	["+"] = true,
	["("] = true,
	[")"] = true,
	["["] = true,
	["]"] = true,
	["{"] = true,
	["}"] = true,
}

local function literal_test_pattern(name)
	return (name:gsub(".", function(character)
		return regex_metacharacters[character] and ("\\" .. character) or character
	end))
end

local function command(ctx, test_name)
	if ctx.runner == "vitest" then
		local args = { "run", ctx.file }
		if test_name then
			vim.list_extend(args, { "-t", literal_test_pattern(test_name) })
		end
		return js_package.exec(ctx.root, "vitest", args)
	end

	local args = { ctx.file, "--runInBand" }
	if test_name then
		vim.list_extend(args, { "-t", literal_test_pattern(test_name) })
	end
	return js_package.exec(ctx.root, "jest", args)
end

local function open_terminal(ctx, args, name, track_exit)
	require("lazy").load({ plugins = { "toggleterm.nvim" } })
	local Terminal = require("toggleterm.terminal").Terminal
	local terminal = Terminal:new({
		cmd = table.concat(vim.tbl_map(vim.fn.shellescape, args), " "),
		dir = ctx.root,
		direction = "horizontal",
		close_on_exit = false,
		display_name = name,
		on_exit = track_exit and function(term)
			term.js_test_watch_alive = false
			if watch_terminal == term then
				watch_terminal = nil
			end
		end or nil,
	})
	if track_exit then
		terminal.js_test_watch_alive = true
	end
	terminal:toggle()
	return terminal
end

local function active_watch_terminal()
	if not watch_terminal or not watch_terminal.js_test_watch_alive or not watch_terminal.job_id then
		return
	end
	local ok, statuses = pcall(vim.fn.jobwait, { watch_terminal.job_id }, 0)
	if ok and statuses[1] == -1 then
		return watch_terminal
	end
	watch_terminal.js_test_watch_alive = false
	watch_terminal = nil
end

local function open_watch_terminal(ctx, args)
	local previous = active_watch_terminal()
	if previous then
		previous.js_test_watch_alive = false
		watch_terminal = nil
		previous:shutdown()
	end
	watch_terminal = open_terminal(ctx, args, "JavaScript test watch", true)
end

local function run(test_name)
	local ctx = context()
	vim.cmd.write()
	test_terminal = open_terminal(ctx, command(ctx, test_name), "JavaScript tests")
end

function M.run_nearest()
	run(M.nearest_test_name())
end

function M.run_file()
	run()
end

function M.run_project()
	local ctx = context()
	vim.cmd.write()
	local args = ctx.runner == "vitest" and js_package.exec(ctx.root, "vitest", { "run" })
		or js_package.exec(ctx.root, "jest", { "--runInBand" })
	test_terminal = open_terminal(ctx, args, "JavaScript tests")
end

function M.watch_nearest()
	local ctx = context()
	local name = literal_test_pattern(M.nearest_test_name())
	local args = ctx.runner == "vitest" and js_package.exec(ctx.root, "vitest", { ctx.file, "-t", name })
		or js_package.exec(ctx.root, "jest", { ctx.file, "--watch", "-t", name })
	vim.cmd.write()
	open_watch_terminal(ctx, args)
end

function M.watch_file()
	local ctx = context()
	local args = ctx.runner == "vitest" and js_package.exec(ctx.root, "vitest", { ctx.file })
		or js_package.exec(ctx.root, "jest", { ctx.file, "--watch" })
	vim.cmd.write()
	open_watch_terminal(ctx, args)
end

function M.rerun_failed()
	local watcher = active_watch_terminal()
	if watcher then
		watcher:send("f")
		return
	end
	local ok, ctx = pcall(context)
	if not ok then
		vim.notify("No active JavaScript test watcher; start watch mode from a JavaScript package", vim.log.levels.INFO)
		return
	end
	if ctx.runner == "jest" then
		local args = js_package.exec(ctx.root, "jest", { "--onlyFailures", "--runInBand" })
		test_terminal = open_terminal(ctx, args, "Failed Jest tests")
		return
	end
	vim.notify("Start Vitest watch mode first; then <leader>nr sends its failed-tests command", vim.log.levels.INFO)
end

function M.debug_nearest()
	local ctx = context()
	local test_name = literal_test_pattern(M.nearest_test_name())
	local program
	local args

	if ctx.runner == "vitest" then
		program = js_package.resolve(ctx.root, "vitest/vitest.mjs")
		args = { "run", ctx.file, "-t", test_name, "--no-file-parallelism" }
	else
		-- Extensionless: jest 29+ ships an "exports" map that publishes only
		-- "./bin/jest", so "jest/bin/jest.js" fails to resolve. Node appends the
		-- .js itself for packages without an exports map.
		program = js_package.resolve(ctx.root, "jest/bin/jest")
		-- Coverage instrumentation (istanbul) rewrites the file and breaks
		-- breakpoint line mapping: a breakpoint lands inside a generated
		-- cov_*() counter instead of your source line. Projects that set
		-- collectCoverage in jest.config need this off to be debuggable.
		args = { ctx.file, "--runInBand", "--coverage=false", "-t", test_name }
	end

	vim.cmd.write()
	require("lazy").load({ plugins = { "nvim-dap" } })
	local runtime, runtime_args = js_package.debug_runtime(ctx.root)
	require("dap").run({
		name = ("Debug nearest %s test"):format(ctx.runner),
		type = "pwa-node",
		request = "launch",
		runtimeExecutable = runtime,
		runtimeArgs = runtime_args,
		program = program,
		args = args,
		cwd = ctx.root,
		console = "integratedTerminal",
		internalConsoleOptions = "neverOpen",
		skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
	})
end

return M
