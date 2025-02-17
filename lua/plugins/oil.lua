return {
  -- Install oil.nvim with lazy.nvim
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        -- Configuration options for oil.nvim
        default_file_explorer = true,
        view_options = {
          show_hidden = true, -- Show hidden files if needed
        },
      })
    end,
    keys = {
      -- Open oil in the current buffer's directory
      {
        ";;",
        function()
          local buf_path = vim.api.nvim_buf_get_name(0) -- Get the current buffer path
          local cwd = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":h") or
              vim.fn.getcwd()                           -- Use its folder or fallback to cwd
          require("oil").open(cwd)                      -- Open oil in the directory of the current file
        end,
        desc = "Open Oil in current directory"
      },

      -- Create a new file in the current buffer's directory
      {
        ";f",
        function()
          local buf_path = vim.api.nvim_buf_get_name(0) -- Get current buffer path
          local cwd = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":h") or
              vim.fn.getcwd()                           -- Use its folder or fallback to cwd
          require("oil").new_file(cwd)                  -- Create a new file in the current buffer's folder
        end,
        desc = "Create new file in current directory"
      },
    }
  }
}
