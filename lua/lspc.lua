local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(_, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = false })
end)

require("lspconfig").tsserver.setup({
	single_file_support = true,
})

local lua_opts = lsp_zero.nvim_lua_ls()
require("lspconfig").lua_ls.setup(lua_opts)

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "tsserver", "lua_ls", "clangd" },
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
		lua_ls = function()
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
	},
})

require("mason-tool-installer").setup({
	ensure_installed = {
		{ "bash-language-server", auto_update = true },
		"vim-language-server",
		"prettier",
		"prettierd",
		"clang-format",
	},
	integrations = {
		["mason-lspconfig"] = true,
		["mason-null-ls"] = true,
		["mason-nvim-dap"] = true,
	},
})

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local cmp_format = require("lsp-zero").cmp_format({ details = true })
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	experimental = {
		ghost_text = true,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "luasnip" },
		{ name = "nvim_lua" },
	},
	formatting = cmp_format,
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp_action.luasnip_supertab(),
		["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),

		["<C-Space>"] = cmp.mapping.complete(),

		["<C-f>"] = cmp_action.luasnip_jump_forward(),
		["<C-b>"] = cmp_action.luasnip_jump_backward(),

		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-y>"] = cmp.mapping.confirm({ select = false }),
		["<C-e>"] = cmp.mapping.abort(),
		["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
		["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
		["<C-p>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item({ behavior = "insert" })
			else
				cmp.complete()
			end
		end),
		["<C-n>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item({ behavior = "insert" })
			else
				cmp.complete()
			end
		end),
	}),
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})

lsp_zero.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		["tsserver"] = { "javascript", "typescript" },
		["rust_analyzer"] = { "rust" },
		["clangd"] = { "c", "c++" },
	},
})

lsp_zero.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
})

local map = vim.keymap.set

local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
