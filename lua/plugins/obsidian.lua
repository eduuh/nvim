local function get_available_workspaces(workspaces)
	local function path_exists(path)
		local expanded_path = vim.fn.expand(path)
		local ok = vim.loop.fs_stat(expanded_path)
		return ok ~= nil
	end

	local available_workspaces = {}

	for _, workspace in ipairs(workspaces) do
		if path_exists(workspace.path) then
			table.insert(available_workspaces, workspace)
		end
	end

	return available_workspaces
end

local workspaces = {
	{
		name = "notes",
		path = "~/projects/byte_safari/content/",
		strict = true,
		overrides = {
			notes_subdir = "inbox",
		},
	},
	{
		name = "work",
		path = "~/projects/work-notes/",
		strict = true,
		overrides = {
			notes_subdir = "inbox",
		},
	},
	{
		name = "personal",
		path = "~/projects/private-notes/",
		strict = true,
		overrides = {
			notes_subdir = "inbox",
		},
	},
}

local valid_workspaces = get_available_workspaces(workspaces)

return {
	"epwalsh/obsidian.nvim",
	enabled = not require("config.utils").isCodeSpace,
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<leader>cn",
			function()
				vim.cmd("ObsidianNew")
			end,
			desc = "Create Note",
		},
		-- Open
		{
			"<leader>on",
			"<cmd>ObsidianQuickSwitch<cr>",
			desc = "Open Note",
		},
		{
			"<leader>ow",
			"<cmd>ObsidianWorkspace<cr>",
			desc = "Open Workspace",
		},
		{
			"<leader>ft",
			"<cmd>ObsidianTags<cr>",
			desc = "Open Workspace",
		},
	},
	config = function()
		require("obsidian").setup({
			ui = {
				enable = false,
			},
			completion = {
				nvim_cmp = false,
				min_chars = 2,
			},
			workspaces = valid_workspaces,
			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "inbox",
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
				-- Use existing front matter if it already exists
				local current_metadata = note.metadata or {}

				-- Define default values for missing fields
				local default_metadata = {
					id = note.id or "",
					title = note.title or "",
					tags = note.tags or "default-tag",
					date = note.date or "general", -- Default area
					excerpt = note.excerpt or "description", -- Default project
					image = note.image or "image path", -- Default priority
					status = note.status or "draft", -- Default related notes
				}

				-- Merge defaults into the existing metadata only for missing keys
				for key, value in pairs(default_metadata) do
					if current_metadata[key] == nil then
						current_metadata[key] = value
					end
				end

				return current_metadata
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
	end,
}
