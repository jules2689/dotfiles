" Clipboard
set clipboard=unnamed

" Set encoding
set encoding=utf-8

" Add plugins
execute pathogen#infect()

" Make vim fast.
set synmaxcol=300
set ttyfast

" set ttyscroll=3 " gone in neovim
set lazyredraw

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Set Whitepsace for shell files too
au FileType sh set nowrap tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Remove trailing whitespaces
autocmd BufWritePre * :%s/\s\+$//e

" Line Numbers
set rnu
set nu

" Color Scheme
colorscheme desert

let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files . -co --exclude-standard']
" let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

