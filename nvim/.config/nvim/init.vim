" Settings
set history=500
set autoread "read when a file is externally changed
set showmatch           " Show matching brackets.
set number              " Show the line numbers on the left side.
set formatoptions+=o    " Continue comment marker in new lines.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=4           " Render TABs using this many spaces.
set shiftwidth=4        " Indentation amount for < and > commands.i
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)
set ignorecase          " Make searching case insensitive
set smartcase           " ... unless th e query has capital letters.<Paste>

"dein: plugin manager
if &compatible
    set nocompatible
endif

" append to runtime path
set rtp+=/usr/share/vim/vimfiles
if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')
    call dein#add('~/.cache/dein')
    call dein#add('vim-airline/vim-airline')
    call dein#add('Shougo/deoplete.nvim')
    call dein#add('zchee/deoplete-clang')
    call dein#add('roxma/nvim-yarp')
    call dein#add('zchee/deoplete-jedi')
    call dein#add('zchee/deoplete-zsh')
    call dein#add('tpope/vim-fugitive')
    call dein#add('tpope/vim-rhubarb')
    call dein#add('SevereOverfl0w/deoplete-github')
    call dein#add('Shougo/neco-vim')
    call dein#add('arakashic/chromatica.nvim')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('neomake/neomake')
    call dein#add('sbdchd/neoformat')


    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

"plugin specific settings
"call dein#update()
call neomake#configure#automake('nrwi', 500)
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
let g:deoplete#sources#clang#clang_header = "/usr/lib/clang"
let g:deoplete#sources = {}
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
let g:chromatica#responsive_mode=1
let g:deoplete#sources.gitcommit=['github']
let g:airline_powerline_fonts = 1

"Neoformat configuration
let g:neoformat_basic_format_align = 1
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1
augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
augroup END

"Airline Customization
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = '' "options: '␤' '¶'

