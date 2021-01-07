execute pathogen#infect()
call plug#begin()

Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }

Plug 'valloric/youcompleteme'

Plug 'vim-airline/vim-airline-themes'

Plug 'ctrlpvim/ctrlp.vim'

call plug#end()

syntax on
filetype plugin indent on

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

map <C-n> :NERDTreeToggle<CR>

:set number

colorscheme challenger_deep

set mouse=a

set tabstop=4
set shiftwidth=4
set expandtab

" Golang Lint "
set rtp+=$GOPATH/src/golang.org/x/lint/misc/vim
autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow

" Airline config "
let g:airline_theme='deus'
let g:airline#extensions#tabline#enabled = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_powerline_fonts = 1
let g:airline_symbols.crypt = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.spell = '暈'

let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/](doc|tmp|node_modules)',
    \ }

set clipboard=unnamedplus

hi Normal guibg=NONE ctermbg=NONE

autocmd CompleteDone * pclose
