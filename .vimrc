" =============================================================================
" General and Miscellaneous
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
set mouse=a            " Mouses are useful for visual selection
packadd! matchit       " Lets % work better
let g:vimsyn_embed = 'l' " Embed lua syntax highlight in vimscript


" Set cursor line
set cursorline
autocmd BufEnter * setlocal cursorline    " Enable when entering window
autocmd BufLeave * setlocal nocursorline  " Disable when leaving window
hi CursorLine cterm=NONE ctermbg=239

" Color fix in tmux
set background=dark

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


" =============================================================================
" Key mappings
" =============================================================================
" General
nnoremap H ^
nnoremap L $
nnoremap ; :

nnoremap <C-z> :sus<CR>
nnoremap <C-c> :noh<CR>

let mapleader = "\<space>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>qq :q<CR>
nnoremap <Leader>qa :qa<CR>
nnoremap <Leader>s :sp<CR>
nnoremap <Leader>v :vsp<CR>
nnoremap <Leader>p :echo expand('%')<CR>

" <C-c> and <ESC> are not the same
inoremap <C-c> <ESC>

" Closing brackets
inoremap (<CR> (<CR>)<ESC>O
inoremap {<CR> {<CR>}<ESC>O
inoremap [<CR> [<CR>]<ESC>O

" Move visual selection up and down
function! MoveDown(count) abort range
  if visualmode() == 'V' && a:lastline != line('$')
    let amount = min([a:count, line('$')-a:lastline])
    exec "'<,'>move '>+" . amount
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction

function! MoveUp(count) abort range
  if visualmode() == 'V' && a:firstline != 1
    let amount = min([a:count, a:firstline-1]) + 1
    exec "'<,'>move '<-" . amount
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction

xnoremap J :call MoveDown(v:count1)<CR>
xnoremap K :call MoveUp(v:count1)<CR>

" * and # obey smartcase
nnoremap <silent> * :let @/='\v<'.expand('<cword>').'>'<CR>:let v:searchforward=1<CR>n
nnoremap <silent> # :let @/='\v<'.expand('<cword>').'>'<CR>:let v:searchforward=0<CR>n
nnoremap <silent> g* :let @/='\v'.expand('<cword>')<CR>:let v:searchforward=1<CR>n
nnoremap <silent> g# :let @/='\v'.expand('<cword>')<CR>:let v:searchforward=0<CR>n

" Toggle relativenumber
function! s:toggle_relnum() abort
  if &relativenumber
    set norelativenumber
  else
    set relativenumber
  endif
endfunction

nnoremap <silent> <Leader>r :call <SID>toggle_relnum()<CR>


" =============================================================================
" Autocommands
" =============================================================================
" Highlight search results only in command mode
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Pick up where I left off
autocmd BufReadPost *
  \   if line("'\"") > 0 && line("'\"") <= line("$")
  \ |   exe "norm g`\""
  \ | endif

" Fix autoread
autocmd FocusGained,BufEnter * :checktime

" Tmux window renaming
if exists('$TMUX')
  autocmd BufEnter,FocusGained * call system("tmux rename-window " . expand("%:t"))
  autocmd VimLeave * call system("tmux rename-window zsh")
endif

" Resize splits when vim size changes
autocmd VimResized * execute "normal! \<c-w>="


" =============================================================================
" Language settings
" =============================================================================
" Verilog
autocmd FileType verilog setlocal shiftwidth=4 tabstop=4 softtabstop=4


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
Plug 'gruvbox-community/gruvbox'
" git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" navigation
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'justinmk/vim-sneak'
Plug 'christoomey/vim-tmux-navigator'
" semantic language support
if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  Plug 'nvim-lua/diagnostic-nvim'
else
  Plug 'prabirshrestha/async.vim' " for vim-lsp
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete.vim' " for asyncomplete-vim
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
endif
if executable('ccls')
  Plug 'jackguo380/vim-lsp-cxx-highlight'
endif
" syntactic language support
Plug 'sheerun/vim-polyglot'
Plug 'vim-syntastic/syntastic'
Plug 'rust-lang/rust.vim'
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
nnoremap <Leader>sc :SyntasticCheck<CR>
nnoremap <Leader>sr :SyntasticReset<CR>
nnoremap <Leader>si :SyntasticInfo<CR>

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
" fugitive
" =============================================================================
nnoremap <Leader>gs :G<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gd :Gdiffsplit!<CR>

" Actually mappings for diff, not fugitive
nnoremap <Leader>gh :diffget //2<CR>
nnoremap <Leader>gl :diffget //3<CR>


" =============================================================================
" vim-gitgutter
" =============================================================================
highlight GitGitterAdd ctermfg=Green
highlight GitGutterChange ctermfg=Yellow
highlight GitGutterDelete ctermfg=Red


" =============================================================================
" gruvbox
" =============================================================================
let g:gruvbox_invert_selection = 0
let g:gruvbox_sign_column = 'bg0'

colorscheme gruvbox

" Transparency fix for Alacritty
" This needed to be done after setting the colorscheme.
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

" No error highlighting
hi! Error NONE


" =============================================================================
" Tagbar
" =============================================================================
nnoremap <silent> <Leader>t :TagbarToggle<CR>

" first show in the order that appears in the source
let g:tagbar_sort = 0


" =============================================================================
" NERDTree
" =============================================================================
" NERDTreeToggle but does not move focus
function! s:NERDTreeToggleNoFocus()
  if exists("g:NERDTree_open_no_focus") && g:NERDTree_open_no_focus == 1
    NERDTreeClose
    let g:NERDTree_open_no_focus = 0
  else
    NERDTreeFind
    wincmd p
    let g:NERDTree_open_no_focus = 1
  endif
endfunction
nnoremap <silent> <C-f> :NERDTreeFind<CR>
nnoremap <silent> <Leader>n :call <SID>NERDTreeToggleNoFocus()<CR>

" Open NERDTree on startup
function! s:NERDTreeStartup()
  if (&diff == 0 && argc() != 0 && &columns > 125)
    call <SID>NERDTreeToggleNoFocus()
  endif
endfunction
if @% != ""
  autocmd VimEnter * silent call <SID>NERDTreeStartup()
endif

" Quit NERDTree when its the only window open
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Key mappings
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
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
else
  let $FZF_DEFAULT_COMMAND = 'find . -type f -not -path "*/.git/*"'
endif

" Key bindings to be pressed on fzf list
let g:fzf_action = {
  \ 'ctrl-g': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

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
  \ { 'width': 0.8, 'height': 0.8, 'yoffset': 0.5, 'xoffset': 0.5, 'border': 'sharp' } }


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
" LSP
" =============================================================================
" key bindings
nnoremap <F2> <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> ge :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gw :lua vim.lsp.buf.workspace_symbol()<CR>

sign define LspDiagnosticsErrorSign text=✖
sign define LspDiagnosticsWarningSign text=⚠
sign define LspDiagnosticsInformationSign text=ℹ
sign define LspDiagnosticsHintSign text=➤

highlight! LspDiagnosticsError cterm=italic gui=italic
highlight! LspDiagnosticsErrorFloating cterm=italic gui=italic
highlight! LspDiagnosticsWarning cterm=italic gui=italic
highlight! LspDiagnosticsWarningFloating cterm=italic gui=italic
highlight! LspDiagnosticsInformation cterm=italic gui=italic
highlight! LspDiagnosticsInformationFloating cterm=italic gui=italic
highlight! LspDiagnosticsHint cterm=italic gui=italic
highlight! LspDiagnosticsHintFloating cterm=italic gui=italic

setlocal signcolumn=yes

lua << END
local lsp = require'nvim_lsp'
local on_attach = function(client)
  require'diagnostic'.on_attach()
  require'completion'.on_attach()
end

if vim.fn.executable('ccls') then
  lsp.ccls.setup{
    on_attach = on_attach,
    init_options = {
      client = {snippetSupport = false},
      highlight = {lsRanges = true}
    }
  }
  vim.api.nvim_command('autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc')
end

if vim.fn.executable('pyls') then
  lsp.pyls.setup{
    on_attach = on_attach
  }
end

if vim.fn.executable('dotnet') then
  lsp.pyls_ms.setup{
    on_attach = on_attach,
    cmd = {
      "dotnet",
      "exec",
      vim.fn.expand("~") .. "/.local/python-language-server/output/bin/Debug/Microsoft.Python.LanguageServer.dll"
    }
  }
  vim.api.nvim_command('autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc')
end

if vim.fn.executable('rls') then
  lsp.rls.setup{
    on_attach = on_attach,
    settings = {rust = {clippy_preference = on}}
  }
  vim.api.nvim_command('autocmd FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc')
end
END

" completion-nvim
" just enable for all buffers
" autocmd BufEnter * lua require'completion'.on_attach()

" Use <Tab> and <S-Tab> to nativage the popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

set completeopt=menuone,noinsert,noselect
set shortmess+=c

" diagnostic-vim
set updatetime=100
autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()
