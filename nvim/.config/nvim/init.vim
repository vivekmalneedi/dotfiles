" Settings
set history=500
set autoread "read when a file is externally changed
set showmatch           " Show matching brackets.
set number              " Show the line numbers on the left side.
set formatoptions+=o    " Continue comment marker in new lines.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=2           " Render TABs using this many spaces.
set shiftwidth=2        " Indentation amount for < and > commands.
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
    call dein#add('Konfekt/FastFold')
    call dein#add('farmergreg/vim-lastplace') "open to previous position
    call dein#add('cloudhead/neovim-fuzzy')

    " UI
    call dein#add('vim-airline/vim-airline')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('metakirby5/codi.vim')
    call dein#add('easymotion/vim-easymotion') "new movement motions
    call dein#add('scrooloose/nerdtree')
    call dein#add('Xuyuanp/nerdtree-git-plugin')

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
    call dein#add('jiangmiao/auto-pairs')

    " git/github
    call dein#add('tpope/vim-fugitive') "git extension
    call dein#add('tpope/vim-rhubarb') "github extension
    call dein#add('airblade/vim-gitgutter') "adds git diff

    " colors
    call dein#add('chrisbra/colorizer') "converts color codes to colors
    call dein#add('mhartington/oceanic-next') "syntax theme
    call dein#add('arakashic/chromatica.nvim') "clang based syntax highligting
    call dein#add('mboughaba/i3config.vim') "i3 config syntax highlighting

    call dein#end()
    call dein#save_state()
endif

"general
nnoremap <C-p> :FuzzyOpen<CR>

"Syntax Highlighting
filetype plugin indent on
syntax enable
"let g:oceanic_next_terminal_bold = 1
"let g:oceanic_next_terminal_italic = 1
"colorscheme monokai
let g:chromatica#responsive_mode=1

" deoplete tab-complete
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

"Airline Customization
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = '' "options: '␤' '¶'
let g:airline_powerline_fonts = 1
let g:airline_theme='oceanicnext'
let g:airline#extensions#tabline#enabled = 1
map <C-j> :bn<CR>
map <C-k> :bp<CR>

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

let g:ale_javascript_prettier_options = '--no-bracket-spacing'
let g:ale_use_global_executables = 1

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

"Nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
"let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

"easymotion
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
