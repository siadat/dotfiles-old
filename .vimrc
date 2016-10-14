let mapleader=';'

call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'pangloss/vim-javascript'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go', { 'tag': '*' }
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 0
let g:go_doc_keywordprg_enabled = 0 " Disable 'K' in Normal mode for showing man

" build and run
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>i  <Plug>(go-install)
autocmd FileType go nmap <leader>D  <Plug>(go-doc)
" _disabled_" (Use gd instead) autocmd FileType go nmap <leader>d  <Plug>(go-def)

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Plug 'jiangmiao/auto-pairs'

" Add plugins to &runtimepath
call plug#end()

nnoremap <c-p> :FZF!<cr>
" knnoremap <c-p> <plug>(fzf-complete-file-ag)

syntax on
set incsearch
set hlsearch
set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set visualbell
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
" set number
" set numberwidth=1
set complete=.,w,b,u,t,i,d,U
set diffopt=filler,iwhite
set wildmenu
silent !mkdir -p ~/.vim/backup
silent !mkdir -p ~/.vim/swp
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

nnoremap <c-q> <c-w>
nmap <leader>w :up<cr>
nmap <leader>q :q<cr>
nmap <leader>/ /<up>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <leader>v :e ~/.vimrc<cr>

" code reading
" nnoremap J jzz
" nnoremap K kzz

colo slate

" _disabled_ These will break going to the line reported by goimports/gofmt by
" pressing ENTER on a quickfix line.
" nnoremap <c-n> :cn<cr>
" nnoremap <c-m> :cp<cr>

" CopyDefaultRegisterToLongterm copies the default unnamed register (@) to the
" 'L' register (@L).
function! CopyDefaultRegisterToLongterm(...)
  " @ is the default register
  " @L is what we use as the long term register
  let @L = @
endfunction
nnoremap Y :call CopyDefaultRegisterToLongterm()<cr>
nnoremap <leader>p :normal "Lp<cr>
nnoremap <leader>P :normal "LP<cr>

function! RegisterLastChangedLine(...)
  let @l = getline("'.")
endfunction
nnoremap <leader>l :call RegisterLastChangedLine() \| normal "lp<cr>
nnoremap <leader>L :call RegisterLastChangedLine() \| normal "lP<cr>

function! CopyFilenameToClipboard()
  silent !tmux set-buffer %
  redraw!
endfunction
nnoremap <leader>g :call CopyFilenameToClipboard()<cr>

function! Seq(...)
  " Examples:
  "   :call Seq(0, 99)
  "   :call Seq('00', '99')
  let cmd = "echo {" . a:1 . ".." . a:2 . "} | perl -pe 's/ /\\n/g'"
  exe "r!" . cmd
endfunction
