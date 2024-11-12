local M = {}

function M.clangd_setup()
	require("clangd_extensions").setup({
		inlay_hints = {
			inline = vim.fn.has("nvim-0.10") == 1,
			-- Options other than `highlight' and `priority' only work
			-- if `inline' is disabled
			-- Only show inlay hints for the current line
			only_current_line = false,
			-- Event which triggers a refresh of the inlay hints.
			-- You can make this { "CursorMoved" } or { "CursorMoved,CursorMovedI" } but
			-- not that this may cause  higher CPU usage.
			-- This option is only respected when only_current_line and
			-- autoSetHints both are true.
			only_current_line_autocmd = { "CursorHold" },
			-- whether to show parameter hints with the inlay hints or not
			show_parameter_hints = true,
			-- prefix for parameter hints
			parameter_hints_prefix = "<- ",
			-- prefix for all the other hints (type, chaining)
			other_hints_prefix = "=> ",
			-- whether to align to the length of the longest line in the file
			max_len_align = false,
			-- padding from the left if max_len_align is true
			max_len_align_padding = 1,
			-- whether to align to the extreme right or not
			right_align = false,
			-- padding from the right if right_align is true
			right_align_padding = 7,
			-- The color of the hints
			highlight = "Comment",
			-- The highlight group priority for extmark
			priority = 100,
		},
		ast = {
			-- These are unicode, should be available in any font
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
			--[[ These require codicons (https://github.com/microsoft/vscode-codicons)
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },

            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            }, ]]

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
		cmake_command = "cmake", -- this is used to specify cmake command path
		ctest_command = "ctest", -- this is used to specify ctest command path
		cmake_regenerate_on_save = true, -- auto generate when save CMakeLists.txt
		cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
		cmake_build_directory = function()
			if osys.iswin32 then
				return "build\\${variant:buildType}"
			end
			return "build/${variant:buildType}"
		end, -- this is used to specify generate directory for cmake, allows macro expansion, can be a string or a function returning the string, relative to cwd.
		cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
		cmake_compile_commands_from_lsp = false, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
		cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
		cmake_variants_message = {
			short = { show = true }, -- whether to show short message
			long = { show = true, max_length = 40 }, -- whether to show long message
		},
		cmake_dap_configuration = { -- debug settings for cmake
			name = "cpp",
			type = "cpp",
			request = "launch",
			stopOnEntry = false,
			runInTerminal = true,
			console = "integratedTerminal",
		},
		cmake_executor = { -- executor to use
			name = "quickfix", -- name of the executor
			opts = {}, -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
			default_opts = { -- a list of default and possible values for executors
				quickfix = {
					show = "always", -- "always", "only_on_error"
					position = "belowright", -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
					size = 10,
					encoding = "utf-8", -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
					auto_close_when_success = false, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
				},
				toggleterm = {
					direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
					close_on_exit = false, -- whether close the terminal when exit
					auto_scroll = true, -- whether auto scroll to the bottom
					singleton = true, -- single instance, autocloses the opened one, if present
				},
				overseer = {
					new_task_opts = {
						strategy = {
							"toggleterm",
							direction = "horizontal",
							autos_croll = true,
							quit_on_exit = false,
						},
					}, -- options to pass into the `overseer.new_task` command
					on_new_task = function(task)
						require("overseer").open({ enter = false, direction = "right" })
					end, -- a function that gets overseer.Task when it is created, before calling `task:start`
				},
				terminal = {
					name = "Main Terminal",
					prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
					split_direction = "horizontal", -- "horizontal", "vertical"
					split_size = 11,

					-- Window handling
					single_terminal_per_instance = true, -- Single viewport, multiple windows
					single_terminal_per_tab = true, -- Single viewport per tab
					keep_terminal_static_location = true, -- Static location of the viewport if avialable

					-- Running Tasks
					start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
					focus = false, -- Focus on terminal when cmake task is launched.
					do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
				}, -- terminal executor uses the values in cmake_terminal
			},
		},
		cmake_runner = { -- runner to use
			name = "quickfix", -- name of the runner
			opts = {}, -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
			default_opts = { -- a list of default and possible values for runners
				quickfix = {
					show = "always", -- "always", "only_on_error"
					position = "belowright", -- "bottom", "top"
					size = 10,
					encoding = "utf-8",
					auto_close_when_success = false, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
				},
				toggleterm = {
					direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
					close_on_exit = false, -- whether close the terminal when exit
					auto_scroll = true, -- whether auto scroll to the bottom
					singleton = true, -- single instance, autocloses the opened one, if present
				},
				overseer = {
					new_task_opts = {
						strategy = {
							"toggleterm",
							direction = "horizontal",
							autos_croll = true,
							quit_on_exit = false,
						},
					}, -- options to pass into the `overseer.new_task` command
					on_new_task = function(task) end, -- a function that gets overseer.Task when it is created, before calling `task:start`
				},
				terminal = {
					name = "Main Terminal",
					prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
					split_direction = "horizontal", -- "horizontal", "vertical"
					split_size = 11,

					-- Window handling
					single_terminal_per_instance = true, -- Single viewport, multiple windows
					single_terminal_per_tab = true, -- Single viewport per tab
					keep_terminal_static_location = true, -- Static location of the viewport if avialable

					-- Running Tasks
					start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
					focus = false, -- Focus on terminal when cmake task is launched.
					do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
				},
			},
		},
		cmake_notifications = {
			runner = { enabled = true },
			executor = { enabled = true },
			spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
			refresh_rate_ms = 100, -- how often to iterate icons
		},
		cmake_virtual_text_support = true, -- Show the target related to current file using virtual text (at right corner)
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
