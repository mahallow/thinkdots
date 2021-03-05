set number relativenumber


call plug#begin('~/.vim/plugged')


Plug 'https://github.com/itchyny/lightline.vim.git'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'junegunn/vim-easy-align'
Plug 'frazrepo/vim-rainbow'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdtree'


call plug#end()
set paste
set splitbelow splitright
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }
colo PaperColor 
map<F7> :NERDTree <CR>
let NERDTreeShowHidden=1
map<F5> :setlocal spell! spelllang=en_US<CR>
set background=dark
set ignorecase
set wildmode=longest,list,full



