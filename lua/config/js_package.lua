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

function M.resolve(root, request)
	local manager = M.manager(root)
	local command = manager == "yarn" and { "yarn", "node" } or manager == "bun" and { "bun" } or { "node" }
	if vim.fn.executable(command[1]) ~= 1 then
		error(("Cannot resolve %s: %s is not executable"):format(request, command[1]))
	end

	vim.list_extend(command, {
		"-e",
		[[
try {
  const request = process.argv[process.argv.length - 1]
  process.stdout.write("__NVIM_JS_RUNNER__" + require.resolve(request, { paths: [process.cwd()] }) + "\n")
} catch (error) {
  console.error(error && error.message ? error.message : error)
  process.exit(1)
}]],
		request,
	})
	local result = vim.system(command, { cwd = root, text = true }):wait()
	local program = (result.stdout or ""):match("__NVIM_JS_RUNNER__([^\r\n]+)")
	if result.code ~= 0 or not program or program == "" then
		local detail = vim.trim(result.stderr or "")
		if detail == "" then
			detail = ("resolver exited with code %d and returned no path"):format(result.code)
		end
		error(("Cannot resolve %s with %s in %s: %s"):format(request, manager, root, detail))
	end
	return program
end

function M.debug_runtime(root)
	local manager = M.manager(root)
	if manager == "yarn" then
		return "yarn", { "node" }
	end
	if manager == "bun" then
		return "bun"
	end
	return "node"
end

return M
