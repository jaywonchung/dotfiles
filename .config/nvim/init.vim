" =============================================================================
" General and Miscellaneous
" =============================================================================
" Options
" whitespace
set autoindent                  " Insert indent on newline
set cindent                     " Autoindent for C
set smartindent                 " Aware of {, }, etc
set scrolloff=2                 " Lines between cursor and screen
set softtabstop=2               " Width of <tab>
set tabstop=2                   " Width of interpretation of <tab>
set shiftwidth=2                " Width of >> and <<
set expandtab                   " <Tab> to spaces, <C-v><Tab> for real tab
set smarttab                    " <Tab> at line start obeys shiftwidth
set backspace=eol,start,indent  " Backspace same as other programs
" command mode
set wildmenu                    " Command mode autocompletion list
set wildmode=longest:full,full  " <Tab> spawns wildmenu, then <Tab> to cycle list
set ignorecase                  " Case-insensitive search
set smartcase                   " ... except when uppercase characters are typed
set incsearch                   " Search as I type
" file
set autoread                    " Auto load when current file is edited somewhere
" performance
set lazyredraw                  " Screen not updated during macros, etc
" vimdiff
set diffopt+=iwhite             " Ignore whitespace
set diffopt+=algorithm:patience " Use the patience algorithm
set diffopt+=indent-heuristic   " Internal diff lib for indents
" appearance
set showmatch                   " Highlight matching braces
set guicursor=                  " Use terminal-default cursor shape
set background=dark             " Dark background
set number relativenumber       " Show relative line number
" misc
set mouse=a                     " Mouses are useful for visual selection
set history=256                 " History for commands, searches, etc

" Embed lua syntax highlighting in vimscript
let g:vimsyn_embed = 'l'

" Set cursor line
set cursorline
autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

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

" Suspend vim
nnoremap <C-z> :suspend<CR>

" Unhighlight all search highlights
nnoremap <silent> <C-c> :noh<CR>

" Leader mappings
let mapleader = "\<space>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>qw :wq<CR>
nnoremap <Leader>qq :q<CR>
nnoremap <Leader>qa :qa<CR>
nnoremap <Leader>s :sp<CR>
nnoremap <Leader>v :vsp<CR>
nnoremap <Leader>p :echo expand('%')<CR>

" Delete selected area and replace with yanked content
vnoremap <Leader>p "_dP

" <C-c> and <ESC> are not the same
inoremap <C-c> <ESC>
vnoremap <C-c> <ESC>

" Closing brackets
inoremap (<CR> (<CR>)<ESC>O
inoremap {<CR> {<CR>}<ESC>O
inoremap ({<CR> (<bar><bar><space>{<CR>})<ESC>O<ESC>k$hhi

" Surrounding with brackets
nnoremap (<CR> i(<CR><ESC>o)<ESC>k^
nnoremap {<CR> i{<CR><ESC>o}<ESC>k^
nnoremap [<CR> i[<CR><ESC>o]<ESC>k^

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


" =============================================================================
" Autocommands
" =============================================================================
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
" Install vim-plugged if not already
if filereadable(glob('~/.local/share/nvim/site/autoload/plug.vim')) == 0
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')
" editing
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'foosoft/vim-argwrap'
Plug 'junegunn/goyo.vim'
Plug 'ojroques/vim-oscyank'
Plug 'voldikss/vim-floaterm'
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" appearance
Plug 'vim-airline/vim-airline'
" Plug 'sainnhe/sonokai'
Plug 'sainnhe/gruvbox-material'
" Plug 'gruvbox-community/gruvbox'
" git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" navigation
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'junegunn/fzf', {'do': { -> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'justinmk/vim-sneak'
Plug 'christoomey/vim-tmux-navigator'
" language server protocol
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'ojroques/nvim-lspfuzzy'
" syntactic language support
Plug 'rust-lang/rust.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
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
" oscyank
" =============================================================================
vnoremap <silent> <Leader>c :OSCYank<CR>


" =============================================================================
" vim-floaterm
" =============================================================================
" Size
let g:floaterm_height = 0.7
let g:floaterm_width = 0.7

" Close window when process exits
let g:floaterm_autoclose = 2

" Open and hide. <C-d> to exit.
nnoremap <Leader>x :FloatermToggle<CR>
tnoremap <C-z> <C-\><C-n>:FloatermHide<CR>

" Wrappers
command! Vifm FloatermNew vifm

" Disable welcome message
let g:floaterm_shell = 'WELCOME=no /usr/bin/zsh'


" =============================================================================
" markdown-preview
" =============================================================================
let g:mkdp_auto_close = 0


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
" Copy from another highlight group
function! CopyFrom(to, from, term, reset)
  let terms = execute('highlight ' . a:from)
  let target = matchstr(terms, a:term . '=\S*')
  if a:reset
    let command = 'highlight! '
  else
    let command = 'highlight '
  endif
  execute('silent ' . command . a:to . ' ' . target)
endfunction

" 24-bit RGB colors
set termguicolors

" Colorscheme-specific configs
let g:sonokai_style = 'default'
let g:gruvbox_material_enable_italic = 0
let g:gruvbox_material_disable_italic_comment = 1
let g:gruvbox_material_palette = 'original'
let g:gruvbox_material_transparent_background = 1
let g:gruvbox_material_statusline_style = 'original'

colorscheme gruvbox-material

let g:airline_theme = 'gruvbox_material'

" Transparent tabline
highlight! TabLineFill NONE

" Search matches (from gruvbox-community)
highlight! Search    cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
highlight! IncSearch cterm=reverse ctermfg=208 ctermbg=235 gui=reverse guifg=#fe8019 guibg=#282828

" Vimdiff (from gruvbox-community)
highlight! DiffText   cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
highlight! DiffAdd    cterm=reverse ctermfg=142 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
highlight! DiffDelete cterm=reverse ctermfg=167 ctermbg=235 gui=reverse guifg=#fb4934 guibg=#282828

" Current line number (fg from Yellow, bg from CursorLine)
call CopyFrom('CursorLineNr', 'Yellow',     'ctermfg', 1)
call CopyFrom('CursorLineNr', 'CursorLine', 'ctermbg', 0)
call CopyFrom('CursorLineNr', 'Yellow',     'guifg',   0)
call CopyFrom('CursorLineNr', 'CursorLine', 'guibg',   0)

" Transparency fix for terminal emulators (Not needed for gruvbox_material)
" highlight! Normal ctermbg=NONE guibg=NONE 
" highlight! SignColumn ctermbg=NONE guibg=NONE
" highlight! EndOfBuffer ctermbg=NONE guibg=NONE
" highlight! NonText ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE


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
  if (&diff == 0 && &columns > 125)
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
  \   'ctrl-s': 'split',
  \   'ctrl-v': 'vsplit' }

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
nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gw :lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gD :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> gn :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> gp :lua vim.lsp.diagnostic.goto_prev()<CR>

lua << END
local lspconfig = require'lspconfig'
local on_attach = function(client)
  require'completion'.on_attach(client)
end

if vim.fn.executable('ccls') == 1 then
  lspconfig.ccls.setup{
    on_attach = on_attach,
    init_options = {
      client = {snippetSupport = false},
      highlight = {lsRanges = true}
    }
  }
  vim.cmd('autocmd FileType c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType c,cpp setlocal signcolumn=yes')
end

if vim.fn.executable('pyls') == 1 then
  lspconfig.pyls.setup{
    on_attach = on_attach,
    settings = {
      pyls = {plugins = {pycodestyle = {ignore = {"E501"}}}}
    }
  }
  vim.cmd('autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType python setlocal signcolumn=yes')
end

if vim.fn.executable('dotnet') == 1 then
  lspconfig.pyls_ms.setup{
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

if vim.fn.executable('rust-analyzer') == 1 then
  lspconfig.rust_analyzer.setup{
    on_attach = on_attach,
  }
  vim.cmd('autocmd FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType rust setlocal signcolumn=yes')
end

-- Configs for diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Virtual text appearance
    virtual_text = {
      spacing = 4,
    },
    -- Do not update in insert mode
    update_in_insert = false,
  }
)

-- Configs for lspfuzzy
require'lspfuzzy'.setup{}
END

" Use tab to bring up and traverse completion list
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

set completeopt=menuone,noinsert,noselect
set shortmess+=c

" lsp_extensions.nvim
autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = '  » '}


" =============================================================================
" rust.vim
" =============================================================================
let g:rust_recommended_style = 0


" =============================================================================
" nvim-treesitter
" =============================================================================
lua << END
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "python", "rust", "lua" },
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
}
END


" =============================================================================
" Must-be-done-at-the-end config
" =============================================================================
set secure exrc                 " Execute .vimrc in the directory vim is started
