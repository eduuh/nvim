return {
	{
		"akinsho/toggleterm.nvim",
		keys = {
			{ [[<C-n>]], mode = { "n", "i", "t" } },
			{ [[<C-t>]], mode = { "n", "i" } },
			{ ";c", mode = "n" },
			{ "<leader>ts", mode = { "n", "v" } },
		},
		cmd = { "ToggleTerm", "TermExec" },
		version = "*",
		config = function()
			local Terminal = require("toggleterm.terminal").Terminal

			require("toggleterm").setup({
				open_mapping = [[<C-n>]],
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					end
				end,
				hide_numbers = true,
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = false,
				direction = "float",
				close_on_exit = true,
				shell = "zsh",
				float_opts = {
					border = "rounded",
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
				winbar = {
					enabled = true,
					name_formatter = function(term)
						return tostring(term.count or term.id or "")
					end,
				},
				on_open = function(term)
					local opts = { buffer = term.bufnr, noremap = true, silent = true }
					vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
					vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
					vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
					vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
					vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
				end,
			})

			-- Named terminals
			local lazygit = Terminal:new({
				cmd = "lazygit",
				direction = "float",
				hidden = true,
				float_opts = {
					border = "rounded",
				},
				on_open = function(term)
					vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = term.bufnr, noremap = true })
				end,
			})

			local horizontal = Terminal:new({
				direction = "horizontal",
				hidden = true,
			})

			local build = Terminal:new({
				direction = "horizontal",
				hidden = true,
			})

			-- Keymaps
			vim.keymap.set("n", ";c", function()
				lazygit:toggle()
			end, { noremap = true, silent = true, desc = "Lazygit" })

			vim.keymap.set({ "n", "i" }, "<C-t>", function()
				horizontal:toggle()
			end, { noremap = true, silent = true, desc = "Toggle horizontal terminal" })

			vim.keymap.set("n", "<leader>ts", function()
				require("toggleterm").send_lines_to_terminal("single_line", false, { args = vim.v.count })
			end, { noremap = true, silent = true, desc = "Send line to terminal" })

			vim.keymap.set("v", "<leader>ts", function()
				require("toggleterm").send_lines_to_terminal("visual_lines", false, { args = vim.v.count })
			end, { noremap = true, silent = true, desc = "Send selection to terminal" })

			-- Terminal autocmds
			vim.api.nvim_create_autocmd("TermOpen", {
				pattern = "term://*",
				callback = function()
					vim.opt_local.number = false
					vim.opt_local.relativenumber = false
					vim.opt_local.signcolumn = "no"
					vim.cmd("startinsert")
				end,
			})
		end,
	},
}
