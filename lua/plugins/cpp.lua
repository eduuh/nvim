local M = {}

function M.clangd_setup()
	require("clangd_extensions").setup({
		inlay_hints = {
			inline = vim.fn.has("nvim-0.10") == 1,
			only_current_line = false,
			only_current_line_autocmd = { "CursorHold" },
			show_parameter_hints = true,
			parameter_hints_prefix = "<- ",
			other_hints_prefix = "=> ",
			max_len_align = false,
			max_len_align_padding = 1,
			right_align = false,
			right_align_padding = 7,
			highlight = "Comment",
			priority = 100,
		},
		ast = {
			role_icons = {
				type = "🄣",
				declaration = "🄓",
				expression = "🄔",
				statement = ";",
				specifier = "🄢",
				["template argument"] = "🆃",
			},
			kind_icons = {
				Compound = "🄲",
				Recovery = "🅁",
				TranslationUnit = "🅄",
				PackExpansion = "🄿",
				TemplateTypeParm = "🅃",
				TemplateTemplateParm = "🅃",
				TemplateParamObject = "🅃",
			},
			highlights = {
				detail = "Comment",
			},
		},
		memory_usage = {
			border = "none",
		},
		symbol_info = {
			border = "none",
		},
	})
end

function M.cmake_tools_setup()
	local osys = require("cmake-tools.osys")
	require("cmake-tools").setup({
		cmake_command = "cmake",
		ctest_command = "ctest",
		cmake_regenerate_on_save = true,
		cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
		cmake_build_directory = function()
			if osys.iswin32 then
				return "build\\${variant:buildType}"
			end
			return "build/${variant:buildType}"
		end,
		cmake_soft_link_compile_commands = true,
		cmake_compile_commands_from_lsp = false,
		cmake_kits_path = nil,
		cmake_variants_message = {
			short = { show = true },
			long = { show = true, max_length = 40 },
		},
		cmake_dap_configuration = {
			name = "cpp",
			type = "cpp",
			request = "launch",
			stopOnEntry = false,
			runInTerminal = true,
			console = "integratedTerminal",
		},
		cmake_executor = {
			name = "quickfix",
			opts = {},
			default_opts = {
				quickfix = {
					show = "always",
					position = "belowright",
					size = 10,
					encoding = "utf-8",
					auto_close_when_success = false,
				},
				toggleterm = {
					direction = "float",
					close_on_exit = false,
					auto_scroll = true,
					singleton = true,
				},
				overseer = {
					new_task_opts = {
						strategy = {
							"toggleterm",
							direction = "horizontal",
							autos_croll = true,
							quit_on_exit = false,
						},
					},
					on_new_task = function()
						require("overseer").open({ enter = false, direction = "right" })
					end,
				},
				terminal = {
					name = "Main Terminal",
					prefix_name = "[CMakeTools]: ",
					split_direction = "horizontal",
					split_size = 11,
					single_terminal_per_instance = true,
					single_terminal_per_tab = true,
					keep_terminal_static_location = true,
					start_insert = false,
					focus = false,
					do_not_add_newline = false,
				},
			},
		},
		cmake_runner = {
			name = "quickfix",
			opts = {},
			default_opts = {
				quickfix = {
					show = "always",
					position = "belowright",
					size = 10,
					encoding = "utf-8",
					auto_close_when_success = false,
				},
				toggleterm = {
					direction = "float",
					close_on_exit = false,
					auto_scroll = true,
					singleton = true,
				},
				overseer = {
					new_task_opts = {
						strategy = {
							"toggleterm",
							direction = "horizontal",
							autos_croll = true,
							quit_on_exit = false,
						},
					},
					on_new_task = function() end,
				},
				terminal = {
					name = "Main Terminal",
					prefix_name = "[CMakeTools]: ",
					split_direction = "horizontal",
					split_size = 11,
					single_terminal_per_instance = true,
					single_terminal_per_tab = true,
					keep_terminal_static_location = true,
					start_insert = false,
					focus = false,
					do_not_add_newline = false,
				},
			},
		},
		cmake_notifications = {
			runner = { enabled = true },
			executor = { enabled = true },
			spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
			refresh_rate_ms = 100,
		},
		cmake_virtual_text_support = true,
	})
end

return {
	{
		"p00f/clangd_extensions.nvim",
		event = "VeryLazy",
		dependencies = "neovim/nvim-lspconfig",
		config = function()
			M.clangd_setup()
		end,
	},
	{
		"Civitasv/cmake-tools.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim", "stevearc/overseer.nvim", "akinsho/toggleterm.nvim" },
		config = function()
			M.cmake_tools_setup()
		end,
	},
}
