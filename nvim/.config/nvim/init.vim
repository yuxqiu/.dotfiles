set autoindent

" Turn syntax highlighting on.
syntax on

" Set utf-8 as encoding
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Add numbers to each line on the left-hand side.
set number

" Set relative Number
set relativenumber

" Shows matching brackets
set showmatch

" Auto tab for some code
set smarttab

" Set shift width to 4 spaces.
set shiftwidth=4
set tabstop=4
set expandtab

" Do not save backup files.
set nobackup
set nowritebackup

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Use highlighting when doing a search.
set hlsearch

" Enable mouse support.
set mouse+=a

" Tab completion
set wildmode=longest,list
set wildmenu

" Folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
" }

" set map leader to be \
let mapleader = ","

" Press the space bar to type the : character in command mode.
nnoremap <space> :

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Jump to start and end of line using the home row keys
noremap H ^
noremap L $

" Use arrow key to move line up and down
nnoremap <A-down> :m .+1<CR>==
nnoremap <A-up> :m .-2<CR>==
inoremap <A-down> <Esc>:m .+1<CR>==gi
inoremap <A-up> <Esc>:m .-2<CR>==gi
vnoremap <A-down> :m '>+1<CR>gv=gv
vnoremap <A-up> :m '<-2<CR>gv=gv

" Press Y to copy to clipboard
nnoremap Y "+y
vnoremap Y "+y
nnoremap yY ^"+y$
" }}}

" Plugins ---------------------------------------------------------------- {
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin()
Plug 'phaazon/hop.nvim'

Plug 'tpope/vim-surround'

Plug 'bkad/camelcasemotion'
call plug#end()

" comment
if exists('g:vscode')
 xmap gc  <Plug>VSCodeCommentary
 nmap gc  <Plug>VSCodeCommentary
 omap gc  <Plug>VSCodeCommentary
 nmap gcc <Plug>VSCodeCommentaryLine
endif

" hop
lua <<EOF
require('hop').setup()
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false })
end, {remap=true})
EOF

" camel case motion
nnoremap <silent> w <Plug>CamelCaseMotion_w
nnoremap <silent> b <Plug>CamelCaseMotion_b
nnoremap <silent> e <Plug>CamelCaseMotion_e

" add vscode folding support
" https://github.com/vscode-neovim/vscode-neovim/issues/58#issuecomment-989481648
if(exists("g:vscode"))
    nnoremap zc :call VSCodeNotify('editor.fold')<CR>
    nnoremap zC :call VSCodeNotify('editor.foldRecursively')<CR>
    nnoremap zo :call VSCodeNotify('editor.unfold')<CR>
    nnoremap zO :call VSCodeNotify('editor.unfoldRecursively')<CR>
endif
