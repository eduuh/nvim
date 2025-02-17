return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "junegunn/fzf",
    "sharkdp/fd",
  },
  config = function()
    local fzf = require("fzf-lua")

    local function yank_path(entry)
      local cb_opts = vim.opt.clipboard:get()
      if vim.tbl_contains(cb_opts, "unnamed") then
        vim.fn.setreg("*", entry.path)
      end
      if vim.tbl_contains(cb_opts, "unnamedplus") then
        vim.fn.setreg("+", entry.path)
      end
      vim.fn.setreg("", entry.path)
      vim.notify("File path copied: " .. entry.path)
    end

    local function is_subpath(basepath, subpath)
      local normalized_base = basepath:gsub("/+$/", "")
      local normalized_sub = subpath:gsub("/+$/", "")
      return normalized_sub:find("^" .. normalized_base) ~= nil
    end

    local function get_cwd()
      local active_path = os.getenv("ACTIVE_PATH") or ""
      local base_dir = vim.fn.getcwd()
      return is_subpath(base_dir, active_path) and active_path or base_dir
    end

    fzf.setup({
      files = {
        cwd = get_cwd(),
        previewer = true,
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case",
        cwd = get_cwd(),
      },
      keymap = {
        fzf = {
          ["ctrl-p"] = "preview-up",
          ["ctrl-n"] = "preview-down",
          ["ctrl-y"] = function(selected)
            yank_path({ path = selected[1] })
          end,
        },
      },
    })

    vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua require'fzf-lua'.files()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>fw", "<cmd>lua require'fzf-lua'.live_grep()<CR>",
      { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>lua browse_files()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>fr", "<cmd>lua require'fzf-lua'.registers()<CR>",
      { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>fd", "<cmd>lua require'fzf-lua'.diagnostics()<CR>",
      { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>fs", "<cmd>lua require'fzf-lua'.treesitter()<CR>",
      { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>oq", "<cmd>lua require'fzf-lua'.quickfix()<CR>",
      { noremap = true, silent = true })
  end,
}
