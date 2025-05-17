---@diagnostic disable: undefined-global
return {
	"tpope/vim-dispatch",
	{
		"vim-test/vim-test",
		enabled = true,
		ft = { "rust", "typescript", "javascript" },
		event = "VeryLazy",
		config = function()
			vim.cmd([[
      let test#strategy = {
      \ 'nearest': 'neovim',
      \ 'file':    'dispatch',
      \ 'suite':   'basic',
    \}
      nmap <silent> <leader>tt :TestNearest<CR>
      nmap <silent> <leader>tT :TestFile<CR>
      nmap <silent> <leader>ta :TestSuite<CR>
      nmap <silent> <leader>tl :TestLast<CR>
      nmap <silent> <leader>tv :TestVisit<CR>
    ]])
		end,
	},
}
