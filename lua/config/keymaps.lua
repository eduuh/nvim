local map = vim.keymap.set

map({ "i", "n" }, "<C-s>", "<cmd>w<CR>", { desc = "Save buffer" })
map({ "n", "v" }, "<BS>", "<C-^>", { desc = "Alternate buffer" })
map("n", ";n", "<cmd>cnext<CR>", { desc = "Next quickfix" })
map("n", ";p", "<cmd>cprev<CR>", { desc = "Prev quickfix" })

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
