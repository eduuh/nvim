-- Show "[n/total]" lenses next to search matches. hlslens only renders while
-- search highlighting is active, so options.lua turns 'hlsearch' on and
-- <Esc> in normal mode clears it (which also hides the lenses).
local function lens(keys)
	return function()
		local ok = pcall(vim.cmd, "normal! " .. vim.v.count1 .. keys)
		if ok then
			require("hlslens").start()
		end
	end
end

local function star(keys)
	return function()
		vim.cmd("normal! " .. keys)
		require("hlslens").start()
	end
end

return {
	"kevinhwang91/nvim-hlslens",
	opts = { calm_down = true },
	keys = {
		{ "n", lens("n"), desc = "Next match (lens)" },
		{ "N", lens("N"), desc = "Prev match (lens)" },
		{ "*", star("*"), desc = "Search word forward (lens)" },
		{ "#", star("#"), desc = "Search word backward (lens)" },
		{ "g*", star("g*"), desc = "Search partial word forward (lens)" },
		{ "g#", star("g#"), desc = "Search partial word backward (lens)" },
		{ "<Esc>", "<Cmd>nohlsearch<CR><Esc>", desc = "Clear search highlight" },
	},
	event = "CmdlineEnter",
}
