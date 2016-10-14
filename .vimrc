syntax on
set nocompatible
filetype plugin on
set modeline
set incsearch
set hlsearch
set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nowrapscan
set ruler
set title
set showcmd
set splitright
set splitbelow
set fileencoding=utf-8
set foldmethod=marker
set foldlevel=0
set foldcolumn=0
set fdo=block,hor,mark,percent,quickfix,search,tag,undo,search
set fml=2
set fen
set laststatus=2
set sidescroll=5
set ignorecase
set smartcase
set noic
set t_Co=256
let mapleader=';'
set complete=.,w,b,u,t,i,d,U
set diffopt=filler,iwhite
set wildmenu

if isdirectory($HOME . '/.vim/backup') == 0
  silent !mkdir -p ~/.vim/backup
endif

if isdirectory($HOME . '/.vim/swp') == 0
  silent !mkdir -p ~/.vim/swp
endif

set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

au BufNewFile,BufRead *.m  setlocal foldmethod=syntax
au BufNewFile,BufRead *.h  setlocal foldmethod=syntax
au BufNewFile,BufRead *.c  setlocal foldmethod=syntax
au BufNewFile,BufRead *.rb setlocal foldmethod=syntax
au BufNewFile,BufRead *.h  nmap <buffer> <leader>t :e <c-r>%<bs>m<cr>
au BufNewFile,BufRead *.m  nmap <buffer> <leader>t :e <c-r>%<bs>h<cr>
au BufNewFile,BufRead *.rb set foldlevel=1
au BufNewFile,BufRead *.js set tabstop=4
au BufNewFile,BufRead *.js set shiftwidth=4
au BufNewFile,BufRead *.go set noexpandtab

imap <tab> <esc>l
vmap <tab> <esc>
nmap <leader>w :up<CR>
nmap <leader>q :q<CR>
nmap <leader>v :e $MYVIMRC<CR>
nmap <C-w>M <C-w><bar><C-w>_
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <CR> i<CR><Esc>
nnoremap # *
nmap <leader>0 o<c-v><c-@><esc>
nnoremap - nzt
nnoremap + Nzt
nmap Y yg_
vmap Y :w! /tmp/sina.vimwide-yank<CR>
nmap <leader>p :read /tmp/sina.vimwide-yank<CR>
nmap dr ver
nnoremap <left>  :bp<CR>
nnoremap <right> :bn<CR>
nnoremap <up>    <NOP>
nnoremap <down>  <NOP>
nnoremap <space> za
nnoremap <leader>s :sp .<cr>:e
nnoremap <leader>S :vs .<cr>:e
nnoremap <leader>d :windo set diff \| set scrollbind \| set foldmethod=diff<cr>

if filereadable($HOME . "/.vimrc-macbook")
  source $HOME/.vimrc-macbook
elseif filereadable($HOME . "/.vimrc-debian")
  source $HOME/.vimrc-debian
endif
