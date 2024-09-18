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

return {
	"vim-test/vim-test",
	"tpope/vim-dispatch",
}
