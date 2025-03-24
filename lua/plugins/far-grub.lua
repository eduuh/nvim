local function grup_far()
	local grug = require("grug-far")
	local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
	grug.open({
		transient = true,
		prefills = {
			filesFilter = ext and ext ~= "" and "*." .. ext or nil,
		},
	})
end

return {
	"MagicDuck/grug-far.nvim",
	opts = { headerMaxWidth = 80 },
	cmd = "GrugFar",
	keys = {
		{ "<leader>sr", grup_far, mode = "n", desc = "Group Far (Normal Mode)" },
		{ "<leader>sr", grup_far, mode = "v", desc = "Group Far (Visual Mode)" },
	},
}
