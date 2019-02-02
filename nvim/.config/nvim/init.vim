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
    "general
    call dein#begin('~/.cache/dein')
    call dein#add('~/.cache/dein')
    call dein#add('vim-airline/vim-airline')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('mboughaba/i3config.vim')
    call dein#add('scrooloose/nerdcommenter')
    call dein#add('jiangmiao/auto-pairs')

    " Completion
    call dein#add('w0rp/ale')
    call dein#add('Shougo/deoplete.nvim') 
    call dein#add('Shougo/neco-syntax')


    " git/github
    call dein#add('tpope/vim-fugitive')
    call dein#add('tpope/vim-rhubarb')

    " colors
    call dein#add('chrisbra/colorizer')
    call dein#add('mhartington/oceanic-next')
    call dein#add('arakashic/chromatica.nvim')

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext

" deoplete tab-complete
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
let g:chromatica#responsive_mode=1
let g:airline_powerline_fonts = 1
let g:airline_theme='oceanicnext'

"Airline Customization
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = '' "options: '␤' '¶'

"NerdCommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

"ale
let g:ale_completion_enabled = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 1
let g:airline#extensions#ale#enabled = 1
let b:ale_fixers = {'python': ['yapf'], 'c++': ['clang-format']}
let b:ale_linters = {'python': ['pyls']}
