package.path = "./lua/?.lua;" .. package.path

local deps = require("config.deps")

local function assert_unique_strings(list, label)
	assert(type(list) == "table", label .. " must be a table")
	assert(#list > 0, label .. " must not be empty")
	local seen = {}
	for _, name in ipairs(list) do
		assert(type(name) == "string" and name ~= "", label .. " entries must be non-empty strings")
		assert(not seen[name], label .. " has a duplicate entry: " .. name)
		seen[name] = true
	end
end

assert_unique_strings(deps.mason, "deps.mason")
assert_unique_strings(deps.treesitter, "deps.treesitter")

local seen = {}
for _, bin in ipairs(deps.binaries) do
	assert(type(bin.cmd) == "string" and bin.cmd ~= "", "every binary needs a cmd")
	assert(type(bin.required) == "boolean", bin.cmd .. " needs an explicit required flag")
	assert(type(bin.why) == "string" and bin.why ~= "", bin.cmd .. " needs a why")
	assert(not seen[bin.cmd], "duplicate binary entry: " .. bin.cmd)
	seen[bin.cmd] = true
end

-- The parsers listed as markdown dependencies must both be present, otherwise
-- tree-sitter-manager installs markdown_inline implicitly and the verification
-- in scripts/bootstrap.lua never checks it.
local parsers = {}
for _, lang in ipairs(deps.treesitter) do
	parsers[lang] = true
end
assert(parsers.markdown and parsers.markdown_inline, "markdown needs markdown_inline alongside it")

-- Anything scripts/install-deps.sh treats as required must be declared here too,
-- so `--check` and the headless run agree on what a working install looks like.
local required = {}
for _, bin in ipairs(deps.binaries) do
	if bin.required then
		required[bin.cmd] = true
	end
end
for _, cmd in ipairs({ "git", "cc", "make", "tree-sitter", "node", "npm" }) do
	assert(required[cmd], cmd .. " must be declared required in deps.binaries")
end

print("deps: ok")
