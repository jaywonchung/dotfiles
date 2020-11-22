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
set diffopt+=algorithm:patience " Use the patience algorithm
set diffopt+=indent-heuristic " Internal diff lib for indents
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
highlight CursorLine cterm=NONE ctermbg=239

" Color fix in tmux
set background=dark

" Syntax highlighting
if has("syntax")
 syntax on
endif

" Persistent undo
if has('persistent_undo')
  let &undodir = stdpath('data') . '/undodir'
  set undofile
  if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
  endif
endif


" =============================================================================
" Key mappings
" =============================================================================
" General
nnoremap H ^
vnoremap H ^
nnoremap L $
vnoremap L $
nnoremap ; :

nnoremap <C-z> :sus<CR>
nnoremap <silent> <C-c> :noh<CR>

let mapleader = "\<space>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>qw :wq<CR>
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

" Diff mappings
nnoremap <Leader>dg :diffget<CR>
nnoremap <Leader>dp :diffput<CR>
nnoremap <Leader>gh :diffget //2<CR>
nnoremap <Leader>gl :diffget //3<CR>

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
"
" e.g.
"              | foo  fool  Foo  Fool
"  ------------|-----------------------
"   *  on foo  |  v          v
"   *  on fool |        v          v
"   *  on Foo  |             v
"   *  on Fool |                   v
"  ------------|-----------------------
"   g* on foo  |  v     v    v     v
"   g* on fool |        v          v
"   g* on Foo  |             v     v
"   g* on Fool |                   v
"
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

" Neovim terminal
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
nnoremap <Leader>x :vsp <Bar> term<CR> a


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

" Highlight yanked text
autocmd TextYankPost * lua require'vim.highlight'.on_yank({"Substitute", 300})


" =============================================================================
" Language settings
" =============================================================================
" Verilog
autocmd FileType verilog setlocal shiftwidth=4 tabstop=4 softtabstop=4


" =============================================================================
" Plugins
" =============================================================================
call plug#begin(stdpath('data') . '/plugged')
" editing
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'foosoft/vim-argwrap'
Plug 'junegunn/goyo.vim'
Plug 'mbbill/undotree'
" appearance
Plug 'vim-airline/vim-airline'
Plug 'sainnhe/sonokai'
Plug 'sainnhe/gruvbox-material'
Plug 'gruvbox-community/gruvbox'
" git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" navigation
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'justinmk/vim-sneak'
Plug 'christoomey/vim-tmux-navigator'
" semantic language support
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
" syntactic language support
Plug 'sheerun/vim-polyglot'
Plug 'vim-syntastic/syntastic'
Plug 'rust-lang/rust.vim'
call plug#end()


" =============================================================================
" vim-argwrap
" =============================================================================
nnoremap <Leader>aw :ArgWrap<CR>


" =============================================================================
" goyo
" =============================================================================
nnoremap <silent> <Leader>gy :Goyo<CR>

let g:goyo_width = 90
let g:goyo_height = '90%'


" =============================================================================
" undotree
" =============================================================================
nnoremap <silent> <Leader>u :UndotreeToggle<CR>


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


" =============================================================================
" colorscheme
" =============================================================================
set termguicolors

let g:sonokai_style = 'default'
let g:gruvbox_material_enable_italic = 0
let g:gruvbox_material_disable_italic_comment = 1
let g:gruvbox_material_palette = 'original'
let g:gruvbox_material_transparent_background = 1
let g:gruvbox_material_statusline_style = 'original'

colorscheme gruvbox-material

let g:airline_theme = 'gruvbox_material'

" Search matches (from gruvbox-community)
highlight! Search    cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
highlight! IncSearch cterm=reverse ctermfg=208 ctermbg=235 gui=reverse guifg=#fe8019 guibg=#282828

" Vimdiff (from gruvbox-community)
highlight! DiffText   cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
highlight! DiffAdd    cterm=reverse ctermfg=142 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
highlight! DiffDelete cterm=reverse ctermfg=167 ctermbg=235 gui=reverse guifg=#fb4934 guibg=#282828

" Current line number
highlight! link CursorLineNr Yellow

" Transparency fix for terminal emulators (Not needed for gruvbox_material)
" highlight! Normal ctermbg=NONE guibg=NONE 
" highlight! SignColumn ctermbg=NONE guibg=NONE
" highlight! EndOfBuffer ctermbg=NONE guibg=NONE
" highlight! NonText ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE

" No error highlighting
" highlight! Error NONE


" =============================================================================
" vim-gitgutter
" =============================================================================
" Transparent git gutter backgrounds
let g:gitgutter_set_sign_backgrounds = 1

" The option above clears gutter icon foreground. Re-add.
autocmd VimEnter * highlight link GitGutterAdd Green
autocmd VimEnter * highlight link GitGutterChange Yellow
autocmd VimEnter * highlight link GitGutterChangeDelete Yellow
autocmd VimEnter * highlight link GitGutterDelete Red


" =============================================================================
" Tagbar
" =============================================================================
nnoremap <silent> <Leader>t :TagbarToggle<CR>

" First show in the order that appears in the source
let g:tagbar_sort = 0

" Do not close tagbar on jump
let g:tagbar_autoclose = 0


" =============================================================================
" NERDTree
" =============================================================================
nnoremap <silent> <C-f> :NERDTreeFind<CR>

" NERDTreeToggle but does not move focus
function! NERDTreeToggleNoFocus()
  if (exists("g:NERDTree") && g:NERDTree.IsOpen() == 1)
    NERDTreeClose
  else
    NERDTreeFind
    wincmd p
  endif
endfunction
nnoremap <silent> <Leader>n :call NERDTreeToggleNoFocus()<CR>

" Open NERDTree on startup
function! NERDTreeStartup()
  if (!exists("nerdtree_startup") && &diff == 0 && &columns > 125)
    call NERDTreeToggleNoFocus()
  endif
endfunction
if argc() > 0 
  autocmd VimEnter * silent call NERDTreeStartup()
endif

" Quit NERDTree when its the only window open
function! NERDTreeAutoQuit()
  if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
    q
  endif
endfunction
autocmd BufEnter * silent call NERDTreeAutoQuit()

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
  nnoremap <Leader>ag :Ag<CR>
endif

" fzf command
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
else
  let $FZF_DEFAULT_COMMAND = 'find . -type f -not -path "*/.git/*"'
endif

" Key bindings to be pressed on fzf list
let g:fzf_action =
  \ { 'ctrl-g': 'tab split',
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

" Show in floating window
let g:fzf_layout = 
  \ { 'up':     '~90%',
    \ 'window': { 'width': 0.8, 'height': 0.8, 'yoffset': 0.5, 'xoffset': 0.5, 'border': 'sharp' }}


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
nnoremap <F2>        :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> K  :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD :lua vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gw :lua vim.lsp.buf.workspace_symbol()<CR>

sign define LspDiagnosticsErrorSign text=✖
sign define LspDiagnosticsWarningSign text=⚠
sign define LspDiagnosticsInformationSign text=ℹ
sign define LspDiagnosticsHintSign text=➤

lua << END
-- Whether to set up a specific language server
--   vim.fn.execuatble('ccls') doesn't seem to work.
local setup_ccls = true;
local setup_pyls = true;
local setup_pyls_ms = true;
local setup_rust_analyzer = true;

local lsp = require'lspconfig'
local on_attach = function(client)
  require'completion'.on_attach()
end

if setup_ccls then
  lsp.ccls.setup{
    on_attach = on_attach,
    init_options = {
      client = {snippetSupport = false},
      highlight = {lsRanges = true}
    }
  }
  vim.cmd('autocmd FileType c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType c,cpp setlocal signcolumn=yes')
end

if setup_pyls then
  lsp.pyls.setup{
    on_attach = on_attach,
    settings = {
      pyls = {plugins = {pycodestyle = {ignore = {"E501"}}}}
    }
  }
  vim.cmd('autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType python setlocal signcolumn=yes')
end

if setup_pyls_ms then
  lsp.pyls_ms.setup{
    on_attach = on_attach,
    cmd = {
      "dotnet",
      "exec",
      vim.fn.expand("~") .. "/.local/python-language-server/output/bin/Debug/Microsoft.Python.LanguageServer.dll"
    }
  }
  vim.cmd('autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType python setlocal signcolumn=yes')
end

if setup_rust_analyzer then
  lsp.rust_analyzer.setup{
    on_attach = on_attach,
  }
  vim.cmd('autocmd FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType rust setlocal signcolumn=yes')
end
END

" Use tab to bring up and traverse completion list
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

set completeopt=menuone,noinsert,noselect
set shortmess+=c

" lsp_extensions.nvim
autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' » '}

" diagnostic-vim
" set updatetime=100
" autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()


" =============================================================================
" nvim-treesitter
" =============================================================================
lua << END
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "python", "rust" },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
END
