require("config.options")
require("config.lazy")

vim.keymap.set({ "i", "n" }, "<C-s>", "<Esc>:w<CR>")
vim.keymap.set({ "n", "v" }, "<BS>", "<C-^>")
vim.keymap.set("n", ";n", ":cnext<CR>")
vim.keymap.set("n", ";p", ":cprev<CR>")

vim.cmd([[colorscheme catppuccin]])

-- Branch note (<Space>nn)
-- Opens note.md for the current git branch; if already viewing it, jumps back to alternate buffer.
vim.keymap.set("n", "<leader>nn", function()
  local note_dir = vim.fn.system(os.getenv("HOME") .. "/.bin/bn --path 2>/dev/null"):gsub("%s+$", "")
  if note_dir == "" then
    vim.notify("bn: not in a git repo", vim.log.levels.WARN)
    return
  end
  local note_file = note_dir .. "/note.md"

  if vim.api.nvim_buf_get_name(0) == note_file then
    vim.cmd("buffer #")
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(note_file))
end, { desc = "Open branch note" })
