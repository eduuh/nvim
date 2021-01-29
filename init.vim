set cmdheight=2
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jparise/vim-graphql'
Plug 'sjl/gundo.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'kristijanhusak/defx-git' " Git status column for defx
Plug '907th/vim-auto-save'
Plug 'preservim/nerdcommenter'
Plug 'gruvbox-community/gruvbox'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-repeat'
Plug 'OmniSharp/omnisharp-vim'
Plug 'nickspoons/vim-sharpenup'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'djoshea/vim-autoread'
Plug 'SirVer/ultisnips'
Plug 'mlaursen/vim-react-snippets'
Plug 'epilande/vim-es2015-snippets'
Plug 'HerringtonDarkholme/yats.vim', {'do': 'rm -rf UltiSnips'}
Plug 'pangloss/vim-javascript'
Plug 'wellle/targets.vim'

" make fzf work related to git root of buffer
Plug 'airblade/vim-rooter'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'sheerun/vim-polyglot' "Syntax highlingt for most languages {{{

Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

let g:coc_global_extensions=[ 'coc-emmet', 'coc-docker',  'coc-html' , 'coc-css' ,  'coc-jest','coc-yaml', 'coc-prettier', 'coc-tsserver']
"'' Bracket pair colorizer
Plug 'luochen1990/rainbow'
call plug#end()

inoremap b, {<cr>}<c-o>O<tab>
inoremap b. {}<left>
inoremap [<cr> [<cr>]<c-o>O<tab>
inoremap (<cr> (<cr>)<c-o>O<tab>

let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

"Gudo Trigger {{{
let g:gundo_prefer_python3 = 1


 "signify {{
  let g:signify_vcs_list = ['git']
    " No realtime. Signify auto-saves modified buffers with realtime enabled. wtf.
  let g:signify_realtime = 0
  let g:signify_sign_change = '~'
  let g:signify_sign_delete = '_'
  let g:signify_sign_delete_first_line = '‾'
  " }}}

"fzf {{{
noremap <c-p> :FZF<cr>
"let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_branch_actions = {
      \ 'rebase': {
      \   'prompt': 'Rebase> ',
      \   'execute': 'echo system("{git} rebase {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-r',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \ 'track': {
      \   'prompt': 'Track> ',
      \   'execute': 'echo system("{git} checkout --track {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-t',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \}
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-t': 'tabedit',
      \ 'ctrl-i': 'vsplit',
      \ }

  "Vim Airline {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline_theme='minimalist'
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#coc#enabled = 1
let g:airline_powerline_fonts=1
" Just show the filename (no path) in the tab
let g:airline#extensions#tabline#fnamemod = ':t'
" }}}

let g:sharpenup_map_prefix = ','
" }}}

" AutoSave Settings {{{
let g:auto_save =1 "enable Autosave on Vim startupx
let g:auto_save_write_all_buffers = 1
let g:auto_save_events = ["CursorHold"]
" }}}

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

let g:OmniSharp_popup_options = {
\ 'winhl': 'Normal:NormalFloat'
\}

let g:OmniSharp_popup_mappings = {
\ 'sigNext': '<C-n>',
\ 'sigPrev': '<C-p>',
\ 'pageDown': ['<C-f>', '<PageDown>'],
\ 'pageUp': ['<C-b>', '<PageUp>'],
\ 'lineDown': ['<C-e>', 'n'],
\ 'lineUp': ['<C-y>', 'e']
\}

let g:OmniSharp_diagnostic_exclude_paths = [
\ 'obj\\',
\ '[Tt]emp\\',
\ '\.nuget\\',
\ '\<AssemblyInfo\.cs\>'
\]
let g:OmniSharp_diagnostic_listen = 3 " Listen for diagnostics and update ALE
let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}
let g:OmniSharp_selector_findusages = 'fzf'
autocmd FileType cs nnoremap <leader>rc :!dotnet run<cr>
autocmd FileType cs nnoremap <leader>rt :!dotnet test<cr>

 "}}}
 
set termguicolors
colorscheme gruvbox
set nohlsearch

set viminfo='101,f1 "Save viminfo file to save Marks and Jumps for upto 101, and to include global marks (A-Z)
let mapleader=" "

noremap n gj|noremap e gk|noremap i l
noremap l i|noremap L I
noremap k n|noremap K N
noremap j e|noremap J E
nmap <BS> <C-^>
"noremap ' `|noremap ` '
" The best!
"noremap ; :|noremap : ;
" Sane redo.
noremap U <C-r>
noremap Y y$
cnoremap w!! execute 'silent! write !SUDO_ASKPASS=`which ssh-askpass` sudo tee % >/dev/null' <bar> edit!
noremap <leader>rp :%s//g<left><left>
noremap  <leader>rw ::%s//<C-r><C-w>/g<CR>
" Better tabbing
vnoremap < <gv
vnoremap > >gv
noremap H <C-w>h|noremap I <C-w>l|noremap N <C-w>j|noremap E <C-w>k
" Moving windows around.
noremap <C-w>N <C-w>J|noremap <C-w>E <C-w>K|noremap <C-w>I <C-w>L
" High/Low. Mid remains `M` since <C-m> is unfortunately interpreted as <CR>.
noremap <C-e> H|noremap <C-n> L
" Scroll up/down.
noremap zn <C-y>|noremap ze <C-e>
" }}}
" Tab managements {{{
 " Create a new tab with tu
noremap te :tabedit<CR>
noremap tmp :-tabmove<CR>
noremap tmn :+tabmove<CR>
nmap tl :Unite tab

nnoremap <leader>t :split term://bash<CR>

set noshowmode
set wrap
set linebreak
set shortmess+=I         "hide splash screen 
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

" Spaces & Tabs {{{
set tabstop=4     " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set expandtab     " turns <TAB's> into spaces.
set shiftwidth=2
set updatetime=2000
set autoindent
set smartindent
set mouse=a
set nocursorline
set splitright | set splitbelow
set wildmenu  " Show a menu when using Tab completion
set wildmode=longest,full            " Tab complete longest common string, then each full match.
set completeopt=longest,menuone 
set showcmd
set scrolloff=5 "Show some few more line when using z-enter"
" }}}

set autowrite     " Automatically :write before running commands
set autoread      " Reload files changed outside vim
set autowriteall  " save the buffer content fhe some specific commands are executed"
" tell it to use an undo file
set undofile
" set a directory to store the undo history
set undodir=/home/eduuh/.config/nvim/undo
set ignorecase
set smartcase
set incsearch  "Highlig the search scheme when typing
set wrapmargin=3
set nofoldenable
set foldmethod=manual
syntax on          " enables syntax procesing
set backspace=2   " Backspace deletes like most programs in insert mode
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
filetype plugin indent on
"}}}

"nnoremap <leader>q :q<cr>
tmap <leader>q <C-d>

nnoremap <leader>u :GundoToggle<Esc>
nnoremap <leader>sp :setlocal spell! spelllang=en_us<cr>

vnoremap <leader>p "_dP   "delete and replace with what is in the clipboard

command! R execute "source ~/.config/nvim/init.vim"
command! C execute ":e ~/.config/nvim/init.vim"


" defx 
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
nnoremap <silent> <c-o> :Defx<CR>
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


  "{{{{ Coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile

vmap <leader>f  <Plug>(coc-format-selected) " Range format
nmap <leader>f  <Plug>(coc-format-selected)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"common code actions
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)
nmap <silent> ff <Plug>(coc-format)
"selection of code rangers
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

"commands
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
command! -nargs=0 Format :call CocAction('format')

"status line support
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
inoremap <silent><expr> <c-n> coc#refresh()

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"}}}}
"graphql
au BufNewFile,BufRead *.prisma setfiletype graphql

"UltiSnips
let g:UltiSnipsExpandTrigger='<c-l>'
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-i>"
