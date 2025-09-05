return {
	"GustavEikaas/easy-dotnet.nvim",
	enabled = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("easy-dotnet").setup()
	end,
}
