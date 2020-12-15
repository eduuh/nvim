"Vim Plug {{{
let mapleader=" "
" The idea is to use HNEI as arrows – keeping the traditional Vim homerow style – and changing as
" little else as possible. This means JKL are free to use and NEI need new keys.
" - k/K is the new n/N.
" - s/S is the new i/I ["inSert"].
" - j/J is the new e/E ["Jump" to EOW].
" - l/L skip to the beginning and end of lines. Much more intuitive than ^/$.
" - Ctrl-l joins lines, making l/L the veritable "Line" key.
" - r replaces i as the "inneR" modifier [e.g. "diw" becomes "drw"].
" Colemak Remaps {{{
" HNEI arrows. Swap 'gn'/'ge' and 'n'/'e'.|norhmap gn j|noremap ge k
noremap n gj|noremap e gk|noremap i l
" In(s)ert. The default s/S is synonymous with cl/cc and is not very useful.
noremap l i|noremap L I
" Repeat search.
noremap k n|noremap K N
" BOL/EOL/Join.
"noremap l ^|noremap L $|noremap <C-l> J
" _r_ = inneR text objects.
onoremap l i
" EOW.
noremap j e|noremap J E
" Faster in-line navigation - Takes you to previos buffer
nmap <BS> <C-^>
" Jump to exact mark location with ' instead of line.
"noremap ' `|noremap ` '
" The best!
noremap ; :|noremap : ;
" Sane redo.
noremap U <C-r>
" Y consistent with C and D
noremap Y y$
cnoremap w!! execute 'silent! write !SUDO_ASKPASS=`which ssh-askpass` sudo tee % >/dev/null' <bar> edit!
noremap <leader>rp :%s//g<left><left>
" Better tabbing
vnoremap < <gv
vnoremap > >gv
" Switch tabs with ctrl
" Switch panes with Shift.
noremap H <C-w>h|noremap I <C-w>l|noremap N <C-w>j|noremap E <C-w>k
" Moving windows around.
noremap <C-w>N <C-w>J|noremap <C-w>E <C-w>K|noremap <C-w>I <C-w>L
" High/Low. Mid remains `M` since <C-m> is unfortunately interpreted as <CR>.
noremap <C-e> H|noremap <C-n> L
" Scroll up/down.
noremap zn <C-y>|noremap ze <C-e>
" Back and forth in jump and changelist.
nnoremap gh <C-o>|nnoremap gi <C-i>|nnoremap gH g;|nnoremap gI g,
" Easy CAPS
inoremap <c-u> <ESC>viwUi
nnoremap <c-u> viwU<Esc>
" Use alt + hjkl hnei to resize windows
" nnoremap <M-n>    :resize -2<CR>
" nnoremap <M-e>    :resize +2<CR>
" nnoremap <M-i>    :vertical resize -2<CR>
" nnoremap <M-h>    :vertical resize +2<CR>
" }}}
" Commands {{{
command! R execute "source ~/.config/nvim/init.vim"
command! C execute ":e ~/.config/nvim/init.vim"
" }}}
" Tab managements {{{
 " Create a new tab with tu
noremap te :tabedit<CR>
" Move the t~/.config/nvim/mappings.vimabs with tmn and tmi;:
noremap tmp :-tabmove<CR>
noremap tmn :+tabmove<CR>
nmap tl :Unite tab
" Move around tabs with tn and ti
noremap <Tab> :bnext<CR>
noremap <S-Tab> :bp<CR>
"source ~/.config/nvim/settings.vim
"source ~/.config/nvim/plugins.vim
nnoremap <leader>t :split term://bash<CR>
  augroup terminal_settings
  autocmd!
  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert
  " Ignore various filetypes as those will close terminal automatically
  " Ignore fzf, ranger, coc
  autocmd TermClose term://*
    \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
    \   call nvim_input('<CR>')  |
    \ endif
  augroup END
set noshowmode
set wrap
set linebreak
set shortmess+=F  " to get rid of the file name displayed in the command line bar
set shortmess+=I         "hide splash screen 
" setting the clipboard manager 
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif
" Spaces & Tabs {{{
set tabstop=4     " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set expandtab     " turns <TAB's> into spaces.
set shiftwidth=2
set autoindent
set smartindent
set mouse=a
" change directory to the current buffer when opening files.
" set autochdir
" }}}
" UI Layout {{{
" set number
" set relativenumber
set nocursorline
set splitright | set splitbelow
set wildmenu  " Show a menu when using Tab completion
set wildmode=longest,full            " Tab complete longest common string, then each full match.
set showcmd
set scrolloff=5 "Show some few more line when using z-enter"
" }}}
" Neovim Misc {{{
scriptencoding utf-8
set encoding=utf-8
set visualbell    " stop that ANNOYING beeping
set autowrite     " Automatically :write before running commands
set autoread      " Reload files changed outside vim
set autowriteall  " save the buffer content fhe some specific commands are executed"
" tell it to use an undo file
set undofile
" set a directory to store the undo history
set undodir=/home/eduuh/.config/nvim/undo
" Searching {{{
set hlsearch      " Stop highlight after searching
" set gdefault      " Substitute all matches in a line (i.e. :s///g) by default
set nohlsearch
set ignorecase
set smartcase
set incsearch  "Highlig the search scheme when typing
" Folding {{{
set wrapmargin=0
set nofoldenable
set foldmethod=manual
" }}}
" colors  {{{
syntax on          " enables syntax procesing
set backspace=2   " Backspace deletes like most programs in insert mode
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
filetype plugin indent on
nnoremap <leader>sp :setlocal spell! spelllang=en_us<cr>
"nnoremap <leader>q :q<cr>
tmap <leader>q <C-d>
autocmd BufWritePre markdown %s/\s\+$//e  " automatically remove all trailling whitespaces(allfiles).
  "Refprence for later usage.
autocmd BufWritePost ~/media/data/dm/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }
augroup terminal_settings
  autocmd!
  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert
  " Ignore various filetypes as those will close terminal automatically
  " Ignore fzf, ranger, coc
  autocmd TermClose term://*
    \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
    \   call nvim_input('<CR>')  |
    \ endif
augroup END
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}
call plug#begin('~/.config/nvim/plugged')
" Provides asynchronous execution.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'mhinz/vim-startify'<C-LeftRelease>
Plug 'junegunn/fzf.vim'
Plug 'yasuhiroki/github-actions-yaml.vim'
" nvim ui{{{
Plug 'vim-airline/vim-airline'
"Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline-themes'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'kristijanhusak/defx-git' " Git status column for defx
"Plug 'altercation/vim-colors-solarized'
Plug 'arcticicestudio/nord-vim'
Plug '907th/vim-auto-save'
Plug 'preservim/nerdcommenter'
Plug 'phanviet/vim-monokai-pro'
"}}}
"intergrate fzf with vim {{{ fuzzy finding of files" Layout Look n Feal {{{
" Plug 'itchyny/lightline.vim' " A light and configurable statusline/tabline plugin for Vim
Plug 'christoomey/vim-tmux-navigator'
Plug 'djoshea/vim-autoread'
"Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'OmniSharp/omnisharp-vim'
"Plug 'nickspoons/vim-sharpenup'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
"}}}
" Markdown Support{{{
" Track the engine
Plug 'SirVer/ultisnips' 
Plug 'honza/vim-snippets' " tabular plugin is used to format tables
Plug 'plasticboy/vim-markdown' " Markdown Previewing
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
Plug 'alvan/vim-closetag'
" }}}
" Plugin --Editing {{{
" Plug 'tpope/vim-abolish' " easily search for, substitute, & abbreviate multiple variants of a word
"}}}
" Syntax highlingt for most languages {{{
Plug 'sheerun/vim-polyglot'
" }}}
" Javascript snippets
Plug 'dense-analysis/ale'
Plug 'pangloss/vim-javascript' " JS syntax highlighting and indentation
Plug 'leafgarland/typescript-vim' " TS syntax highlighting
Plug 'maxmellon/vim-jsx-pretty' " JSX and TSX syntax highlighting
Plug 'epilande/vim-es2015-snippets'
Plug 'epilande/vim-react-snippets'
Plug 'ctrlpvim/ctrlp.vim'
" Conquer of Completion {{{
"}}}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions=['coc-eslint', 'coc-json', 'coc-tsserver', 'coc-omnisharp', 'coc-docker',  'coc-html' , 'coc-css' ,  'coc-jest', 'coc-snippets', 'coc-yaml']
" Bracket pair colorizer
Plug 'luochen1990/rainbow'
call plug#end()
let g:OmniSharp_selector_ui = 'fzf'  " Use ctrlp.vim
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
" AutoSave Settings {{{
let g:auto_save =1 "enable Autosave on Vim startupx
augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,typescriptreact,javascript,javascriptreact,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" }}}
nnoremap <silent> <Leader><leader> :Defx<CR>
  call defx#custom#option('_', {
      \ 'columns': 'git:indent:icon:filename',
      \ 'winwidth':30,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': 'Files',
      \ 'toggle': 1,
      \ 'resume': 1,
      \ 'root_marker': '‣‣‣ ',
      \ })
  call defx#custom#column('indent', { 'indent': '  ' })
  call defx#custom#column('git', 'indicators', {
      \ 'Modified'  : '‣',
      \ 'Staged'    : '✚',
      \ 'Untracked' : '✭',
      \ 'Renamed'   : '➜',
      \ 'Unmerged'  : '═',
      \ 'Ignored'   : '☒',
      \ 'Deleted'   : '✖',
      \ 'Unknown'   : '?',
      \ })
" Quit if defx is the last window.
autocmd WinEnter * if &ft == 'defx' && winnr('$') == 1 | q | endif
  " defx mappings.
autocmd FileType defx call s:defx_my_settings()
    function! s:defx_my_settings() abort
      " Define mappings
    nnoremap <silent><buffer><expr> <CR> defx#is_directory() ? defx#do_action('open_or_close_tree') : defx#do_action('open', 'wincmd p \| drop')
    nnoremap <silent><buffer><expr> o defx#is_directory() ? defx#do_action('open_or_close_tree') : defx#do_action('open', 'wincmd p \| drop')
      nnoremap <silent><buffer><expr> s defx#do_action('open', 'wincmd p \| split')
      nnoremap <silent><buffer><expr> v defx#do_action('open', 'wincmd p \| vsplit')
      nnoremap <silent><buffer><expr> t defx#do_action('open', 'tabnew')
      nnoremap <silent><buffer><expr> O defx#do_action('open_tree_recursive')
      nnoremap <silent><buffer><expr> x defx#do_action('close_tree')
      " nnoremap <silent><buffer><expr> go defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> C defx#do_action('cd', defx#get_candidate().action__path)
      nnoremap <silent><buffer><expr> u defx#do_action('cd', '..')
      nnoremap <silent><buffer><expr> a defx#do_action('new_file')
      nnoremap <silent><buffer><expr> A defx#do_action('new_multiple_files')
      nnoremap <silent><buffer><expr> c defx#do_action('copy')
      nnoremap <silent><buffer><expr> p defx#do_action('paste')
      nnoremap <silent><buffer><expr> m defx#do_action('move')
      nnoremap <silent><buffer><expr> r defx#do_action('rename')
      nnoremap <silent><buffer><expr> dd defx#do_action('remove')
      nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
      nnoremap <silent><buffer><expr> H defx#do_action('toggle_ignored_files')
      nnoremap <silent><buffer><expr> R defx#do_action('redraw')
      " nnoremap <silent><buffer><expr> u defx#do_action('cd', ['..'])
      nnoremap <silent><buffer><expr> q defx#do_action('quit')
    endfunction
"}}} 
 "signify {{
  let g:signify_vcs_list = ['git']
    " No realtime. Signify auto-saves modified buffers with realtime enabled. wtf.
  let g:signify_realtime = 0
  let g:signify_sign_add = '+'
  let g:signify_sign_change = '~'
  let g:signify_sign_delete = '_'
  let g:signify_sign_delete_first_line = '‾'
  " }}}
  "Fzf {{{
  " FZF commands
  let g:fzf_command_prefix = 'Fzf'
    " Extra key bindings
    " <C-n> (down), <C-e> (up), etc are mapped via $FZF_DEFAULT_OPTS.
  let g:fzf_action = {
    \ 'ctrl-h': 'topleft vsplit',
    \ 'ctrl-i': 'botright vsplit',
    \ 'H': 'aboveleft vsplit',
    \ 'N': 'belowright split',
    \ 'E': 'aboveleft split',
    \ 'I': 'belowright vsplit',
    \ 'T': 'tab split',
    \ }
    " Open FZF in tmux at bottom of screen.
  let g:fzf_layout = { 'down': '~40%' }
    " Disable statusline overwriting.
  let g:fzf_nvim_statusline = 0
    " [Buffers] Jump to the existing window if possible
  let g:fzf_buffers_jump = 1
    " Hide the statusbar in the FZF pane.
    augroup fzf
      autocmd!
      autocmd! FileType fzf
      autocmd  FileType fzf set laststatus=0 noshowmode noruler
          \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
    augroup END

  command! -bang -nargs=*  All
    \ call fzf#run(fzf#wrap({'source': 'rg --files --hidden --no-ignore-vcs --glob "!{node_modules/*,.git/*}"', 'down': '40%', 'options': '--expect=ctrl-t,ctrl-x,ctrl-v --multi --reverse' }))
  "}}}
  " Vim Airline {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline_theme='minimalist'
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#coc#enabled = 1
let g:airline_powerline_fonts=1
" Just show the filename (no path) in the tab
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
" }}}
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
set updatetime=300
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
\   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
\           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
\   <bang>0)
" GoTo code navigation.
" To make <cr> select the first completion item and confirm the completion
" when item has been selected.
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ca  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>cf  <Plug>(coc-fix-current)
" Use K to show documentation in preview window.
nnoremap <silent><leader>d :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
endfunction
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}%{StatusDiagnostic()}
autocmd BufWritePre markdown %s/\s\+$//e  " automatically remove all trailling whitespaces(allfiles).
"Refprence for later usage.
" autocmd BufWritePost ~/media/data/dm/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }
let g:sharpenup_map_prefix = ','
" }}}
" Autoclose Tag {{{
" Took this directly from the Website
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml'
" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filetypes = 'xhtml,jsx'
" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'
" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'
" }}}
" AutoSave Settings {{{
let g:auto_save =1 "enable Autosave on Vim startupx
" }}}
augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,typescriptreact,javascript,javascriptreact,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" }}}
nnoremap <silent> <Leader><leader> :Defx<CR>
  call defx#custom#option('_', {
      \ 'columns': 'git:indent:icon:filename',
      \ 'winwidth':30,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': 'Files',
      \ 'toggle': 1,
      \ 'resume': 1,
      \ 'root_marker': '‣‣‣ ',
      \ })
  call defx#custom#column('indent', { 'indent': '  ' })
  call defx#custom#column('git', 'indicators', {
      \ 'Modified'  : '‣',
      \ 'Staged'    : '✚',
      \ 'Untracked' : '✭',
      \ 'Renamed'   : '➜',
      \ 'Unmerged'  : '═',
      \ 'Ignored'   : '☒',
      \ 'Deleted'   : '✖',
      \ 'Unknown'   : '?',
      \ })
" Quit if defx is the last window.
autocmd WinEnter * if &ft == 'defx' && winnr('$') == 1 | q | endif
" defx mappings.
autocmd FileType defx call s:defx_my_settings()
  function! s:defx_my_settings() abort
    " Define mappings
  nnoremap <silent><buffer><expr> <CR> defx#is_directory() ? defx#do_action('open_or_close_tree') : defx#do_action('open', 'wincmd p \| drop')
  nnoremap <silent><buffer><expr> o defx#is_directory() ? defx#do_action('open_or_close_tree') : defx#do_action('open', 'wincmd p \| drop')
    nnoremap <silent><buffer><expr> s defx#do_action('open', 'wincmd p \| split')
    nnoremap <silent><buffer><expr> v defx#do_action('open', 'wincmd p \| vsplit')
    nnoremap <silent><buffer><expr> t defx#do_action('open', 'tabnew')
    nnoremap <silent><buffer><expr> O defx#do_action('open_tree_recursive')
    nnoremap <silent><buffer><expr> x defx#do_action('close_tree')
    " nnoremap <silent><buffer><expr> go defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> C defx#do_action('cd', defx#get_candidate().action__path)
    nnoremap <silent><buffer><expr> u defx#do_action('cd', '..')
    nnoremap <silent><buffer><expr> a defx#do_action('new_file')
    nnoremap <silent><buffer><expr> A defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> c defx#do_action('copy')
    nnoremap <silent><buffer><expr> p defx#do_action('paste')
    nnoremap <silent><buffer><expr> m defx#do_action('move')
    nnoremap <silent><buffer><expr> r defx#do_action('rename')
    nnoremap <silent><buffer><expr> dd defx#do_action('remove')
    nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> H defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> R defx#do_action('redraw')
    " nnoremap <silent><buffer><expr> u defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> q defx#do_action('quit')
  endfunction
"}}} 
" Sharpenve C#Code {{{
let g:sharpenup_map_prefix = ','
" }}}
"OmniSharp {{{
" Use Roslyin and also better performance than HTTP
let g:OmniSharp_server_stdio = 1
let g:omnicomplete_fetch_full_documentation = 1
" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 30
let g:OmniSharp_popup_position = 'peek'
if has('nvim')
  let g:OmniSharp_popup_options = {
  \ 'winhl': 'Normal:NormalFloat'
  \}
else
  let g:OmniSharp_popup_options = {
  \ 'highlight': 'Normal',
  \ 'padding': [0, 0, 0, 0],
  \ 'border': [1]
  \}
endif
let g:OmniSharp_popup_mappings = {
\ 'sigNext': '<C-n>',
\ 'sigPrev': '<C-p>',
\ 'pageDown': ['<C-f>', '<PageDown>'],
\ 'pageUp': ['<C-b>', '<PageUp>']
\}

let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}

augroup omnisharp_commands
  autocmd!
  " show type information automatically when the cursor stop moving
  autocmd CursorHold *.cs OmniSharpTypeLookup
  " Contextual, based on the Position
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <leader>fu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>fi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>pd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>pi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>d <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>fs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>fx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
" Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>ca <Plug>(omnisharp_code_actions)
  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader>. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader>. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader>= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>rn <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>rs <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ss <Plug>(omnisharp_start_server)
  autocmd FileType cs nnoremap <leader>rl :OmniSharpReloadSolution<cr>
  autocmd FileType cs nnoremap <leader>cf :OmniSharpCodeFormat<cr>
augroup END
 "}}}
set termguicolors
colorscheme monokai_pro
