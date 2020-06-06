"-------------------------------------------------------------------
" General
"-------------------------------------------------------------------
" Language settings
set langmenu=en_US
let $LANG='en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" General settings
set autoindent 
set cindent " Autoindent for C
set scrolloff=2
set wildmode=longest,list
set softtabstop=2 " Width of <tab>
set tabstop=2 " Width of interpretation of <tab>
set shiftwidth=2 " Width of >> and <<
set autowrite " Auto save when changing to another file
set autoread " Auto load when current file is edited somewhere else
set backspace=eol,start,indent
set history=256
set expandtab
set showmatch " Highlight matching braces
set smartcase " Case sensitive search
set smarttab
set smartindent
set ruler 
set incsearch
set exrc " Execute .vimrc in the directory vim is started
set number relativenumber " Show relative line number
packadd! matchit " Lets % work better

" General key mappings
let mapleader=","
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Highlight current line
set cursorline
autocmd WinEnter * setlocal cursorline    " Enable when entering window
autocmd WinLeave * setlocal nocursorline  " Disable when leaving window
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

" persistent undo
if has('persistent_undo')
  let undodir=$HOME . "/.vim/undodir"
  set undodir=$HOME/.vim/undodir
  set undofile
  if !isdirectory(undodir)
    call mkdir(undodir, "p")
  endif
endif

" mouse mode
set mouse+=a

"-------------------------------------------------------------------
" Vundle
"-------------------------------------------------------------------
set nocompatible
filetype off

" Install vundle if not already installed
if empty(glob('~/.vim/bundle/Vundle.vim'))
  silent !git clone https://github.com/VundleVim/Vundle.vim.git
    \ ~/.vim/bundle/Vundle.vim
  autocmd VimEnter * PluginInstall | source ~/.vimrc
endif

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-commentary' " comment with gc, gcc
Plugin 'prabirshrestha/async.vim' " for vim-lsp
Plugin 'prabirshrestha/vim-lsp' " language server
Plugin 'prabirshrestha/asyncomplete.vim' " for autocomplete-lsp
Plugin 'prabirshrestha/asyncomplete-lsp.vim' " autocompletion with vim-lsp
Plugin 'flazz/vim-colorschemes' " using gruvbox
Plugin 'editorconfig/editorconfig-vim'
call vundle#end()

filetype plugin indent on " re-enable filetype


"-------------------------------------------------------------------
" vim-airline
"-------------------------------------------------------------------
" Show max line number
let g:airline_section_z = airline#section#create(['%3p%%: ', 'linenr', 'maxlinenr', ':%3v'])


"-------------------------------------------------------------------
" Pathogen (installs Syntastic)
"-------------------------------------------------------------------
execute pathogen#infect()


"-------------------------------------------------------------------
" Syntastic
"-------------------------------------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {'mode': 'passive'}

" C
"let g:syntastic_c_compiler_options = ' -std=c11 -Wall -Wextra -Wpedantic -wbuiltin-declaration-mismatch'
let g:syntastic_c_checkers = ['gcc', 'make']
let g:syntastic_c_compiler_options = "-std=c11 -Wall -Wextra -Wpedantic"


"-------------------------------------------------------------------
" NERDTree
"-------------------------------------------------------------------
" Quit NERDTree when its the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" For systems without pretty arrows
" let g:NERDTreeDirArrowExpandable = '>'
" let g:NERDTreeDirArrowCollapsible = 'v'

" Key mappings
nnoremap <C-F> :NERDTreeFind<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>


"-------------------------------------------------------------------
" AsyncRun
"-------------------------------------------------------------------
" Height of quickfix windoe
let g:asyncrun_open = 6
" Toggle quickfix window
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<CR>
" Build single file .c
nnoremap <silent> <F9> :w <bar> AsyncRun gcc "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <CR>
" Run built binary
nnoremap <silent> <F5> :AsyncRun -raw -cwd="$(VIM_FILEDIR)" "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <CR>

command GCC w <bar> AsyncRun gcc "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"
command NVCC w <bar> AsyncRun nvcc "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"
command GoBin AsyncRun -raw -cwd="$(VIM_FILEDIR)" "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"


"-------------------------------------------------------------------
" Tagbar
"-------------------------------------------------------------------
nnoremap <silent> <Leader>t :TagbarToggle<CR>

" auto-open only on supported filetypes
" autocmd FileType * :call tagbar#autoopen(0)

" sort in the order that appears in the source file
let g:tagbar_sort = 0

"-------------------------------------------------------------------
" vim-lsp
"-------------------------------------------------------------------
" basic configurations
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
endfunction
augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" enable logging
"let g:lsp_log_verbose = 1
"let g:lsp_log_file = 'vim-lsp.log'

" key bindings
nnoremap <f2> :LspRename<CR>
nnoremap <silent> gd :LspDefinition<CR>
nnoremap <silent> gr :LspReferences<CR>

" options
let g:lsp_preview_float = 1

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

"-------------------------------------------------------------------
" Goyo
"-------------------------------------------------------------------
nnoremap <C-g> :Goyo<CR>

"-------------------------------------------------------------------
" vim-colorschemes
"-------------------------------------------------------------------
colorscheme gruvbox

" Transparency fix for Alacritty
" This needed to be done after setting the colorscheme.
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

"-------------------------------------------------------------------
" asyncomplete-lsp
"-------------------------------------------------------------------
let g:asyncomplete_auto_popup = 0 " autocompletion popup only when I press tab

function! s:check_back_space() abort
  let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <C-space> <Plug>(asyncomplete_force_refresh)

set completeopt-=preview " disable preview window
autocmd! CompleteDone * pclose " close preview when complete
autocmd InsertLeave * pclose " close preview when leaving insert mode

"-------------------------------------------------------------------
" editorconfig-vim
"-------------------------------------------------------------------
let g:EditorConfig_exclude_patterns = ['fugitive://.*'] " for compatibility with vim-fugitive
