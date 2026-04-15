return {
	{
		"akinsho/toggleterm.nvim",
		keys = [[<c-n>]],
		cmd = { "ToggleTerm", "TermExec" },
		event = "VeryLazy",
		version = "*",
		config = function()
			local inner_conf = vim.fn.stdpath("config") .. "/tmux-inner.conf"

			local function disable_outer_tmux()
				if os.getenv("TMUX") then
					vim.fn.system("tmux set prefix None ; tmux set key-table off ; tmux refresh-client -S")
				end
			end

			local function enable_outer_tmux()
				if os.getenv("TMUX") then
					vim.fn.system("tmux set -u prefix ; tmux set -u key-table ; tmux refresh-client -S")
				end
			end

			vim.keymap.set({ "n", "t" }, "<leader>tu", enable_outer_tmux, { desc = "Unlock outer tmux" })

			require("toggleterm").setup({
				open_mapping = [[<c-n>]],
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = false,
				shell = "tmux -L nvim -f " .. inner_conf .. " new-session -A -s main",
				on_open = function() disable_outer_tmux() end,
				on_close = function() enable_outer_tmux() end,
				float_opts = {
					border = "rounded",
					width = math.floor(vim.o.columns * 0.95),
					height = math.floor(vim.o.lines * 0.92),
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
				winbar = {
					enabled = true,
					name_formatter = function(term)
						return term.count
					end,
				},
			})

			-- Escape terminal mode without killing Claude Code's own Esc handling.
			-- Double-tap Esc exits terminal insert mode; single Esc passes through.
			vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

			-- Claude Code yolo terminal (skips all permission prompts)
			local Terminal = require("toggleterm.terminal").Terminal
			local claude = Terminal:new({
				cmd = "tmux -L nvim -f "
					.. inner_conf
					.. " has-session -t claude 2>/dev/null && tmux -L nvim attach-session -t claude || tmux -L nvim new-session -s claude \\; send-keys 'claude --dangerously-skip-permissions' Enter",
				direction = "float",
				close_on_exit = false,
				on_open = function() disable_outer_tmux() end,
				on_close = function() enable_outer_tmux() end,
				float_opts = {
					border = "rounded",
					width = math.floor(vim.o.columns * 0.95),
					height = math.floor(vim.o.lines * 0.92),
					winblend = 0,
				},
			})
			vim.keymap.set("n", "<leader>cy", function()
				claude:toggle()
			end, { desc = "Claude Code (yolo)" })

			-- Pre-spawn so it's ready when you first open it
			vim.defer_fn(function()
				claude:spawn()
			end, 1000)

			-- Fix mouse and local options for all terminal buffers
			vim.api.nvim_create_autocmd("TermOpen", {
				pattern = "*",
				callback = function()
					vim.opt_local.mouse = ""
					vim.opt_local.scrolloff = 0
					vim.opt_local.signcolumn = "no"
				end,
			})
		end,
	},
}
