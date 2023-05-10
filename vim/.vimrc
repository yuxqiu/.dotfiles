set nocompatible

" Disable startup message 
set shortmess+=I

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

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

" Highlight cursor line underneath the cursor horizontally.
set cursorline

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

" Set format options
au FileType * set fo-=c fo-=r fo-=o

" Tab completion
set wildmode=longest,list
set wildmenu

" set new split panes to right and bottom
set splitbelow
set splitright

" FileType autocmd  -------------------------------------------- {
iabbrev ret return
autocmd FileType c iabbrev <buffer> main int main(int argc, char* argv[]) 
autocmd FileType cpp iabbrev <buffer> main int main(int argc, char* argv[])
autocmd FileType python iabbrev <buffer> main if __name__ == "__main__":
" autocmd FileType json syntax match Comment +\/\/.\+$+

" Folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
" } 

" MAPPINGS --------------------------------------------------------------- {
" map jj to esc in insert mode
inoremap jj <esc>

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

" Move around windows (k is fixed in tnoremap)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-l> <C-w>l

" shell related
noremap <c-k> :term zsh<cr>
inoremap <c-k> :term zsh<cr>
tnoremap <c-k> <c-w>k
tnoremap <esc><esc> <c-\><c-n>:q!<cr>

" Press Y to copy to clipboard
nnoremap Y "+y
vnoremap Y "+y
nnoremap yY ^"+y$
" }}}

" Plugins ---------------------------------------------------------------- {

" easymotion
let g:EasyMotion_smartcase = 1 " turn on case insensitive feature
let g:EasyMotion_do_mapping = 0 " disable default mappings
let g:EasyMotion_use_smartsign_us = 1 " 1 will match 1 and !
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz;'
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_enter_jump_first = 1

nnoremap f <Plug>(easymotion-bd-f)
nnoremap <Leader>/ <Plug>(easymotion-sn)

" jk motions: line motions
noremap <Leader>j <Plug>(easymotion-j)
noremap <Leader>k <Plug>(easymotion-k)

" end of easymotion

" start of NERDTree
noremap <F2> :NERDTreeToggle<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif
" end of NERDTree

" Onedark theme start
packadd! onedark.vim
set termguicolors
colorscheme onedark
" Onedark theme end

" Rainbow
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
let g:rainbow#blacklist = [233,234,235,236,237,238,239,240,241,242,243,244,245,
                          \246,247,248,249,250,251,252,253,254,255]
autocmd FileType * RainbowParentheses

" Lightline - Status Line
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified'] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': []
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ }

" Lightline - tabs
set showtabline=2
let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#enable_devicons = 1

" -- filter out terminal
function LightlineBufferlineFilter(buffer)
  return getbufvar(a:buffer, '&buftype') !=# 'terminal'
endfunction

let g:lightline#bufferline#buffer_filter = "LightlineBufferlineFilter"

" -- open a new buffer
nnoremap <Leader>t :enew<cr>

" -- switch to a buffer
nnoremap <Leader>1 <Plug>lightline#bufferline#go(1)
nnoremap <Leader>2 <Plug>lightline#bufferline#go(2)
nnoremap <Leader>3 <Plug>lightline#bufferline#go(3)
nnoremap <Leader>4 <Plug>lightline#bufferline#go(4)
nnoremap <Leader>5 <Plug>lightline#bufferline#go(5)
nnoremap <Leader>6 <Plug>lightline#bufferline#go(6)
nnoremap <Leader>7 <Plug>lightline#bufferline#go(7)
nnoremap <Leader>8 <Plug>lightline#bufferline#go(8)
nnoremap <Leader>9 <Plug>lightline#bufferline#go(9)
nnoremap <Leader>0 <Plug>lightline#bufferline#go(10)

" -- close a buffer
nnoremap <Leader>cc :bdelete<cr>
nnoremap <Leader>c1 <Plug>lightline#bufferline#delete(1)
nnoremap <Leader>c2 <Plug>lightline#bufferline#delete(2)
nnoremap <Leader>c3 <Plug>lightline#bufferline#delete(3)
nnoremap <Leader>c4 <Plug>lightline#bufferline#delete(4)
nnoremap <Leader>c5 <Plug>lightline#bufferline#delete(5)
nnoremap <Leader>c6 <Plug>lightline#bufferline#delete(6)
nnoremap <Leader>c7 <Plug>lightline#bufferline#delete(7)
nnoremap <Leader>c8 <Plug>lightline#bufferline#delete(8)
nnoremap <Leader>c9 <Plug>lightline#bufferline#delete(9)
nnoremap <Leader>c0 <Plug>lightline#bufferline#delete(10)

" Camel Case Motion
nnoremap <silent> w <Plug>CamelCaseMotion_w
nnoremap <silent> b <Plug>CamelCaseMotion_b
nnoremap <silent> e <Plug>CamelCaseMotion_e
