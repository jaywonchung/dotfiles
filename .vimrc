" =============================================================================
" General
" =============================================================================
" Language settings
set langmenu=en_US
let $LANG='en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Editor settings
" whitespace
set autoindent         " Insert indent on newline
set cindent            " Autoindent for C
set smartindent        " Aware of {, }, etc
set scrolloff=2        " Lines between cursor and screen
set softtabstop=2      " Width of <tab>
set tabstop=2          " Width of interpretation of <tab>
set shiftwidth=2       " Width of >> and <<
set expandtab          " <Tab> to spaces, <C-v><Tab> for real tab
set smarttab           " <Tab> at line start obeys shiftwidth
set backspace=eol,start,indent " Backspace same as other programs
" search
set history=256        " History for commands, searches, etc
set wildmode=longest,list " Command-mode autocompletion
set ignorecase         " Case-insensitive search
set smartcase          " Except when uppercase characters are typed
set incsearch
" file
set autoread           " Auto load when current file is edited somewhere
" performance
set ttyfast
set lazyredraw
" difftool
set diffopt+=iwhite    " Ignore whitespace
silent! set diffopt+=algorithm:patience " Use the patience algorithm
silent! set diffopt+=indent-heuristic " Internal diff lib for indents
" Misc settings
set number relativenumber " Show relative line number
set exrc               " Execute .vimrc in the directory vim is started
set showmatch          " Highlight matching braces
set guicursor=         " Use terminal-default cursor shape
packadd! matchit       " Lets % work better


" General key bindings
let mapleader = "\<space>"
nnoremap H ^
nnoremap L $
nnoremap ; :
nnoremap <C-z> :sus<CR>
nnoremap <C-c> <silent> <C-c>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>qq :q<CR>
nnoremap <Leader>qa :qa<CR>

" Closing brackets
inoremap (<CR> (<CR>)<ESC>O
inoremap {<CR> {<CR>}<ESC>O
inoremap [<CR> [<CR>]<ESC>O

" Highlight search results only in command mode
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Set cursor line
set cursorline
autocmd BufEnter * setlocal cursorline    " Enable when entering window
autocmd BufLeave * setlocal nocursorline  " Disable when leaving window
hi CursorLine cterm=NONE ctermbg=239

" Color fix in tmux
set background=dark

" Pick up where I left off
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif

" Syntax highlighting
if has("syntax")
 syntax on
endif

" Persistent undo
if has('persistent_undo')
  let undodir=$HOME . "/.vim/undodir"
  set undodir=$HOME/.vim/undodir
  set undofile
  if !isdirectory(undodir)
    call mkdir(undodir, "p")
  endif
endif

" Fix autoread
autocmd FocusGained,BufEnter * :checktime


" =============================================================================
" Plugins
" =============================================================================
call plug#begin('~/.vim/plugged')
" editing
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'foosoft/vim-argwrap'
" appearance
Plug 'vim-airline/vim-airline'
Plug 'machakann/vim-highlightedyank'
Plug 'morhetz/gruvbox'
" git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" navigation
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'justinmk/vim-sneak'
Plug 'christoomey/vim-tmux-navigator'
" semantic language support
Plug 'prabirshrestha/async.vim' " for vim-lsp
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim' " for asyncomplete-vim
Plug 'prabirshrestha/asyncomplete-lsp.vim'
" syntactic language support
Plug 'sheerun/vim-polyglot'
Plug 'vim-syntastic/syntastic'
call plug#end()


" =============================================================================
" vim-argwrap
" =============================================================================
nnoremap <Leader>a :ArgWrap<CR>


" =============================================================================
" Syntastic
" =============================================================================
" General configurations
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {'mode': 'passive'}

" Key bindings
nnoremap <Leader>s :w <bar> :SyntasticCheck<CR>
nnoremap <Leader>r :SyntasticReset<CR>
nnoremap <Leader>i :SyntasticInfo<CR>

" C
"let g:syntastic_c_compiler_options = ' -std=c11 -Wall -Wextra -Wpedantic -wbuiltin-declaration-mismatch'
let g:syntastic_c_checkers = ['gcc', 'make']
let g:syntastic_c_compiler_options = "-std=c11 -Wall -Wextra -Wpedantic"


" =============================================================================
" editorconfig-vim
" =============================================================================
let g:EditorConfig_exclude_patterns = ['fugitive://.*'] " for compatibility with vim-fugitive


" =============================================================================
" vim-highlightedyank
" =============================================================================
let g:highlightedyank_highlight_duration = 300


" =============================================================================
" vim-airline
" =============================================================================
" Show max line number
let g:airline_section_z = airline#section#create(['%3p%%: ', 'linenr', 'maxlinenr', ':%3v'])


" =============================================================================
" gruvbox
" =============================================================================
colorscheme gruvbox

" Transparency fix for Alacritty
" This needed to be done after setting the colorscheme.
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

" No error highlighting
hi! Error NONE


" =============================================================================
" fugitive
" =============================================================================
nnoremap <Leader>gd :Gdiff master:%<CR>
nnoremap <Leader>gs :G<CR>
nnoremap <Leader>gh :diffget //2
nnoremap <Leader>gl :diffget //3


" =============================================================================
" Tagbar
" =============================================================================
nnoremap <silent> <Leader>t :TagbarToggle<CR>

" first show in the order that appears in the source
let g:tagbar_sort = 0


" =============================================================================
" NERDTree
" =============================================================================
" Quit NERDTree when its the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Key mappings
nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
let NERDTreeMapOpenInTab='<C-g>'
let NERDTreeMapOpenSplit='<C-s>'
let NERDTreeMapOpenVSplit='<C-v>'

" For systems without pretty arrows
" let g:NERDTreeDirArrowExpandable = '>'
" let g:NERDTreeDirArrowCollapsible = 'v'


" =============================================================================
" fzf
" =============================================================================
" Open fzf window
nnoremap <leader>f :Files<CR>
if executable('ag')
  nnoremap <Leader>g :Ag<CR>
endif

" fzf command
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore .google -g ""'
else
  let $FZF_DEFAULT_COMMAND = 'find . -type f -not -path "*/.git/*" -not -path "*/.google/*"'
endif

" Key bindings to be pressed on fzf list
let g:fzf_action = {
  \ 'ctrl-g': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" Set local history directory
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Match fzf colors with current color scheme
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }

" let g:fzf_layout = { 'down': '~20%' }
let g:fzf_layout = { 'up':'~90%', 'window':
  \ { 'width': 0.8, 'height': 0.8, 'yoffset': 0.5, 'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }


" =============================================================================
" vim-sneak
" =============================================================================
let g:sneak#label = 1
let g:sneak#s_next = 1 " repeating s will take me to the next result

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T


" =============================================================================
" vim-lsp
" =============================================================================
" basic configurations
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
endfunction
augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 0

" enable logging
"let g:lsp_log_verbose = 1
"let g:lsp_log_file = 'vim-lsp.log'

" key bindings
nnoremap <f2> :LspRename<CR>
nnoremap <silent> gd :LspDefinition<CR>
nnoremap <silent> gr :LspReferences<CR>
nnoremap <silent> ge :LspPeekDefinition<CR>

" ccls
if executable('ccls')
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'ccls',
    \ 'cmd': {server_info->['ccls']},
    \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
    \ 'initialization_options': {},
    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
    \ })
endif

" python-language-server
if executable('pyls')
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'pyls',
    \ 'cmd': {server_info->['pyls']},
    \ 'whitelist': ['python'],
    \ })
endif

" rust language server
if executable('rls')
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'rls',
    \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
    \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
    \ 'whitelist': ['rust'],
    \ })
endif


" =============================================================================
" asyncomplete-lsp
" =============================================================================
" Disable auto-popup. Only open on <Tab>.
let g:asyncomplete_auto_popup = 0

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<Tab>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
