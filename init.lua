require("config.options")
require("config.keymapping")
require("config.autocmd")
require("config.ttconfig")
require("config.lazy")
require("config.osconfigs")

-- Experimental- tests: Only on mac
if require("config.utils").isMac then
	require("config.rocks")
end

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
