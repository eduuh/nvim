return {
	"epwalsh/obsidian.nvim",
	enabled = require("config.utils").isMac or require("config.utils").isLinux,
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		["<leader>ont"] = {
			action = function() end,
			opts = { buffer = true },
		},
	},

	config = function()
		require("obsidian").setup({
			workspaces = {
				{
					name = "notes",
					path = "~/projects/byte_safari/",
					overrides = {
						notes_subdir = "inbox",
					},
				},
				{
					name = "personal",
					path = "~/projects/notes",
				},
			},
			completion = {
				nvim_cmp = true,
				min_chars = 2,
			},
			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "notes/dailies",
				-- Optional, if you want to change the date format for the ID of daily notes.
				date_format = "%Y-%m-%d",
				-- Optional, if you want to change the date format of the default alias of daily notes.
				alias_format = "%B %-d, %Y",
				-- Optional, default tags to add to each new daily note created.
				default_tags = { "daily-notes" },
				-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
				template = nil,
			},
			new_notes_location = "inbox/",
			wiki_link_func = function(opts)
				if opts.id == nil then
					return string.format("[[%s]]", opts.label)
				elseif opts.label ~= opts.id then
					return string.format("[[%s|%s]]", opts.id, opts.label)
				else
					return string.format("[[%s]]", opts.id)
				end
			end,

			note_frontmatter_func = function(note)
				-- This is equivalent to the default frontmatter function.
				local out = { id = note.id, aliases = note.aliases, tags = note.tags, area = "", project = "" }

				-- `note.metadata` contains any manually added fields in the frontmatter.
				-- So here we just make sure those fields are kept in the frontmatter.
				if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end
				return out
			end,

			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will be given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.time()) .. "-" .. suffix
			end,

			templates = {
				subdir = "_templates/",
			},
		})

		local keymap = vim.keymap
		local opt = { noremap = true, silent = true }
		keymap.set({ "n" }, "<leader>of", function()
			require("obsidian").util.gf_passthrough()
		end, opt)
		keymap.set({ "n" }, "<leader>od", function()
			return require("obsidian").util.toggle_checkbox()
		end, opt)
		keymap.set({ "n" }, "<leader>on", "<cmd>ObsidianNew<cr>", opt)
		keymap.set({ "n" }, "<leader>oi", function()
			require("obsidian").util.insert_template("Newsletter-Issue")
		end, opt)
		keymap.set({ "n" }, "<leader>oa", function()
			require("obsidian").util.smart_action()
		end, opt)
	end,
}
