" Settings
set history=500
set autoread "read when a file is externally changed
set showmatch           " Show matching brackets.
set number              " Show the line numbers on the left side.
set formatoptions+=o    " Continue comment marker in new lines.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=2           " Render TABs using this many spaces.
set shiftwidth=2        " Indentation amount for < and > commands.i
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)
set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.

set number relativenumber "hybrid line numbers
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

autocmd BufWritePre * :%s/\s\+$//e "remove trailing spaces

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
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
    call dein#add('scrooloose/nerdcommenter') "commenting
    "call dein#add('jiangmiao/auto-pairs') bracket pairing
    call dein#add('Konfekt/FastFold')
    call dein#add('farmergreg/vim-lastplace') "open to previous position

    " UI
    call dein#add('vim-airline/vim-airline')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('metakirby5/codi.vim')

    " Completion
    call dein#add('w0rp/ale') "linting/fixing
    call dein#add('Shougo/deoplete.nvim') "completion
    call dein#add('Shougo/neco-syntax') "completetion plugin that uses language syntax file
    call dein#add('deoplete-plugins/deoplete-jedi') "python
    call dein#add('Shougo/neco-vim')
    call dein#add('deoplete-plugins/deoplete-zsh')
    call dein#add('SevereOverfl0w/deoplete-github')
    call dein#add('Shougo/neoinclude.vim')
    call dein#add('ujihisa/neco-look')
    call dein#add('deoplete-plugins/deoplete-asm')
    call dein#add('Shougo/context_filetype.vim')
    call dein#add('Shougo/neopairs.vim')
    call dein#add('Shougo/echodoc.vim')
    call dein#add('Shougo/deoplete-clangx')
    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')

    " git/github
    call dein#add('tpope/vim-fugitive') "git extension
    call dein#add('tpope/vim-rhubarb') "github extension

    " colors
    call dein#add('chrisbra/colorizer') "converts color codes to colors
    call dein#add('mhartington/oceanic-next') "syntax theme
    call dein#add('arakashic/chromatica.nvim') "clang based syntax highligting
    call dein#add('mboughaba/i3config.vim') "i3 config syntax highlighting

    call dein#end()
    call dein#save_state()
endif

"Syntax Highlighting
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
let g:ale_completion_enabled = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 1
let g:airline#extensions#ale#enabled = 1
let b:ale_fixers = {
      \'python': ['yapf'],
      \'c++': ['clang-format'],
      \'c': ['clang-format'],
      \'cmake': ['cmake-format'],
      \'markdown': ['prettier'],
      \'yaml': ['prettier']}
let b:ale_linters = {
      \'python': ['flake8'],
      \'c++': ['clang', 'cppcheck', 'clang-tidy'],
      \'c': ['clang', 'cppcheck', 'clang-tidy'],
      \'make': ['checkmake'],
      \'cmake': ['cmakelint'],
      \'markdown': ['remark-lint'],
      \'yaml': ['yamllint']}

"Snippets
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
