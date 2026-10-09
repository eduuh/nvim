local map = vim.keymap.set

map({ "i", "n" }, "<C-s>", "<cmd>w<CR>", { desc = "Save buffer" })
map({ "n", "v" }, "<BS>", "<C-^>", { desc = "Alternate buffer" })
map("n", ";n", "<cmd>cnext<CR>", { desc = "Next quickfix" })
map("n", ";p", "<cmd>cprev<CR>", { desc = "Prev quickfix" })
map("n", "<leader>q", "<cmd>qa!<CR>", { desc = "Quit all without saving" })

-- bn editor (see lua/bn/init.lua). Loaded lazily and guarded: these panes are created by
-- `bn edit`, but this config still has to start cleanly anywhere the module is absent.
local function bn(fn)
  return function()
    local ok, m = pcall(require, "bn")
    if ok then
      m[fn]()
    end
  end
end

map("n", "<leader>eh", bn("park"), { desc = "bn: park this editor pane (nvim keeps running)" })
map("n", "<leader>et", bn("toggle"), { desc = "bn: toggle the agent terminal" })
map("n", "<leader>el", bn("relanded"), { desc = "bn: land on this branch's diff" })

-- JS/TS test & debug runners (lua/config/js_tests.lua, js_scripts.lua, dap/jsandts.lua).
-- These live here rather than on the typescript-tools spec because that plugin is
-- disabled in workspaces that ship tsgo, and the runners do not depend on it.
map("n", "<leader>nn", function()
	require("config.js_tests").run_nearest()
end, { desc = "Test nearest" })
map("n", "<leader>nd", function()
	require("config.js_tests").debug_nearest()
end, { desc = "Debug nearest test" })
map("n", "<leader>nf", function()
	require("config.js_tests").run_file()
end, { desc = "Test current file" })
map("n", "<leader>na", function()
	require("config.js_tests").run_project()
end, { desc = "Test project" })
map("n", "<leader>nw", function()
	require("config.js_tests").watch_nearest()
end, { desc = "Watch nearest test" })
map("n", "<leader>nW", function()
	require("config.js_tests").watch_file()
end, { desc = "Watch test file" })
map("n", "<leader>nr", function()
	require("config.js_tests").rerun_failed()
end, { desc = "Rerun failed tests" })
map("n", "<leader>rs", function()
	require("config.js_scripts").pick()
end, { desc = "Run package script" })
map("n", "<leader>rd", function()
	require("config.dap.jsandts").debug_current_file()
end, { desc = "Debug current JS/TS file" })
map("n", "<leader>rD", function()
	require("config.js_scripts").debug_pick()
end, { desc = "Debug package script" })
map("n", "<leader>rb", function()
	require("config.dap.jsandts").attach_browser()
end, { desc = "Attach browser debugger" })
