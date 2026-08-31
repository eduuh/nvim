local M = {}

local managers = {
	{ "pnpm-lock.yaml", "pnpm" },
	{ "yarn.lock", "yarn" },
	{ "bun.lockb", "bun" },
	{ "bun.lock", "bun" },
	{ "package-lock.json", "npm" },
	{ "npm-shrinkwrap.json", "npm" },
}

local function package_manager(root)
	local path = vim.fs.joinpath(root, "package.json")
	if vim.fn.filereadable(path) ~= 1 then
		return
	end
	local ok, package = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
	if not ok or type(package.packageManager) ~= "string" then
		return
	end
	return package.packageManager:match("^([%w-]+)@")
end

local function manager_at(root)
	local declared = package_manager(root)
	if vim.tbl_contains({ "npm", "pnpm", "yarn", "bun" }, declared) then
		return declared
	end
	for _, entry in ipairs(managers) do
		if vim.fn.filereadable(vim.fs.joinpath(root, entry[1])) == 1 then
			return entry[2]
		end
	end
end

function M.manager(root)
	local manager = manager_at(root)
	if manager then
		return manager
	end
	for parent in vim.fs.parents(root) do
		manager = manager_at(parent)
		if manager then
			return manager
		end
	end
	return "npm"
end

function M.root(path)
	local root = vim.fs.root(path, "package.json")
	if not root then
		error("No package.json found for " .. path)
	end
	return root
end

function M.exec(root, package_name, args)
	local manager = M.manager(root)
	local command = manager == "npm" and { "npx", package_name }
		or manager == "bun" and { "bun", "x", package_name }
		or { manager, "exec", package_name }
	vim.list_extend(command, args or {})
	return command
end

function M.script(root, script)
	return { M.manager(root), "run", script }
end

local function resolve_with_node(root, request, script, description)
	local manager = M.manager(root)
	local command = manager == "yarn" and { "yarn", "node" } or manager == "bun" and { "bun" } or { "node" }
	if vim.fn.executable(command[1]) ~= 1 then
		error(("Cannot resolve %s: %s is not executable"):format(request, command[1]))
	end

	vim.list_extend(command, { "-e", script, request })
	local result = vim.system(command, { cwd = root, text = true }):wait()
	local program = (result.stdout or ""):match("__NVIM_JS_RUNNER__([^\r\n]+)")
	if result.code ~= 0 or not program or program == "" then
		local detail = vim.trim(result.stderr or "")
		if detail == "" then
			detail = ("resolver exited with code %d and returned no path"):format(result.code)
		end
		error(("Cannot resolve %s%s with %s in %s: %s"):format(request, description, manager, root, detail))
	end
	return program
end

function M.resolve(root, request)
	return resolve_with_node(
		root,
		request,
		[[
try {
  const request = process.argv[process.argv.length - 1]
  process.stdout.write("__NVIM_JS_RUNNER__" + require.resolve(request, { paths: [process.cwd()] }) + "\n")
} catch (error) {
  console.error(error && error.message ? error.message : error)
  process.exit(1)
}]],
		""
	)
end

function M.resolve_bin(root, package_name)
	return resolve_with_node(
		root,
		package_name,
		[[
try {
  const path = require("path")
  const packageName = process.argv[process.argv.length - 1]
  const manifestPath = require.resolve(`${packageName}/package.json`, { paths: [process.cwd()] })
  const manifest = require(manifestPath)
  const relativeBin = typeof manifest.bin === "string" ? manifest.bin : manifest.bin && manifest.bin[packageName]
  if (!relativeBin) throw new Error(`${packageName} does not declare a ${packageName} executable`)
  process.stdout.write("__NVIM_JS_RUNNER__" + path.resolve(path.dirname(manifestPath), relativeBin) + "\n")
} catch (error) {
  console.error(error && error.message ? error.message : error)
  process.exit(1)
}]],
		" executable"
	)
end

function M.debug_runtime(root)
	local manager = M.manager(root)
	if manager == "yarn" then
		return "yarn", { "node" }
	end
	if manager == "bun" then
		error(
			"Bun debugging is not supported by the installed js-debug adapter. "
				.. "Run it without DAP, or use a Node-compatible project for debugging."
		)
	end
	return "node"
end

function M.debug_context(path)
	local extension = vim.fn.fnamemodify(path, ":e"):lower()
	local ok, root = pcall(M.root, path)
	if not ok then
		if vim.tbl_contains({ "ts", "tsx", "jsx" }, extension) then
			error(("Cannot debug %s directly: create a package.json and install project-local tsx first."):format(path))
		end
		return {
			root = vim.fs.dirname(path),
			runtime = "node",
			runtime_args = {},
			program = path,
			args = {},
		}
	end
	local runtime, runtime_args = M.debug_runtime(root)
	local program = path
	local args = {}
	if vim.tbl_contains({ "ts", "tsx", "jsx" }, extension) then
		local resolved, tsx_path = pcall(M.resolve_bin, root, "tsx")
		if not resolved then
			local manager = M.manager(root)
			local install = manager == "pnpm" and "pnpm add --save-dev tsx"
				or manager == "yarn" and "yarn add --dev tsx"
				or "npm install --save-dev tsx"
			error(
				("Cannot debug %s directly: project-local tsx is required. Run `%s` in %s. %s"):format(
					extension:upper(),
					install,
					root,
					tsx_path
				)
			)
		end
		program = tsx_path
		args = { path }
	end
	return {
		root = root,
		runtime = runtime,
		runtime_args = runtime_args or {},
		program = program,
		args = args,
	}
end

return M
