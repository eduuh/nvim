require("config.options")
require("config.lazy")
require("config.autocmd")

---@diagnostic disable-next-line: undefined-global
local keymap = vim.keymap.set
local map = require("config.utils").map
local opts = { noremap = true, silent = true }

keymap({ "n", "v" }, "<BS>", "<C-^>", opts)

-- Control shortcuts
map({ "i", "n" }, "<C-q>", "<Esc>:q!<CR>", opts)
map({ "i", "n" }, "<C-s>", "<Esc>:w<CR>", opts)

-- Split window
keymap("n", "<leader>h", ":split<Return>", opts)
keymap("n", "<leader>v", ":vsplit<Return>", opts)

keymap("n", "<leader>uu", "<cmd>UndotreeToggle<cr>", opts)

vim.keymap.set("n", "<leader>rn", function()
    local cmdId
    cmdId = vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
        callback = function()
          local key = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
          vim.api.nvim_feedkeys(key, "c", false)
          vim.api.nvim_feedkeys("0", "n", false)
          cmdId = nil
          return true
        end,
      })
    vim.lsp.buf.rename()
    vim.defer_fn(function()
        if cmdId then
          vim.api.nvim_del_autocmd(cmdId)
        end
      end, 500)
  end, {desc ="Rename symbol"})
