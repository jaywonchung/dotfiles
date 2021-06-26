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
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:· " For invisible chars
" command mode
set wildmenu                    " Command mode autocompletion list
set wildmode=longest:full,full  " <Tab> spawns wildmenu, then <Tab> to cycle list
set ignorecase                  " Case-insensitive search
set smartcase                   " ... except when uppercase characters are typed
set incsearch                   " Search as I type
" file
set hidden                      " Allow switching to other buffers without saving
set autoread                    " Auto load when current file is edited somewhere
" performance
set lazyredraw                  " Screen not updated during macros, etc
" vimdiff
set diffopt+=iwhite             " Ignore whitespace
set diffopt+=algorithm:patience " Use the patience algorithm
set diffopt+=indent-heuristic   " Internal diff lib for indents
" appearance
set showmatch                   " Highlight matching braces
set background=dark             " Dark background
set number relativenumber       " Show relative line number
set noshowmode                  " Do not show current mode at the bottom
" misc
set mouse=a                     " Mouses are useful for visual selection
set history=256                 " History for commands, searches, etc

" Embed lua syntax highlighting in vimscript
let g:vimsyn_embed = 'l'

" Set cursor line
set cursorline
autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" Cursor shape: Changes shape based on current mode
set guicursor=n-v:block-Cursor/lCursor-blinkon0,i-c-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
" Use the following to use the terminal-default cursor shape
" set guicursor=

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
inoremap {<CR> {<CR>}<ESC>O

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
function! ToggleRelnum() abort
  if &relativenumber
    set norelativenumber
  else
    set relativenumber
  endif
endfunction

nnoremap <silent> <Leader>r :call ToggleRelnum()<CR>

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

" Resize splits when vim size changes
autocmd VimResized * wincmd =

" Highlight yanked text
autocmd TextYankPost * lua require'vim.highlight'.on_yank({"Substitute", 300})


" =============================================================================
" Language settings
" =============================================================================
" Verilog
autocmd FileType verilog setlocal shiftwidth=4 tabstop=4 softtabstop=4

" Rust
autocmd FileType rust setlocal shiftwidth=4 tabstop=4 softtabstop=4
let g:rustfmt_fail_silently = 1


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
Plug 'hoob3rt/lualine.nvim'
Plug 'sainnhe/gruvbox-material'
Plug 'chriskempson/base16-vim'
Plug 'andreypopp/vim-colors-plain'
" git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" navigation
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'airblade/vim-rooter'
Plug 'justinmk/vim-sneak'
Plug 'christoomey/vim-tmux-navigator'
" language server protocol
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'simrat39/rust-tools.nvim'
" syntactic language support
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

let g:EditorConfig_verbose = 1

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
vnoremap <silent> <Leader>y :OSCYank<CR>


" =============================================================================
" vim-floaterm
" =============================================================================
" Size
let g:floaterm_height = 0.7
let g:floaterm_width = 0.7

" Close window when process exits
let g:floaterm_autoclose = 2

" Open and hide.
nnoremap <CR> :FloatermToggle<CR>
tnoremap <C-z> <C-\><C-n>:FloatermHide<CR>

" Wrappers
command! Vifm FloatermNew vifm

" Disable git plugin inside floaterm
let g:floaterm_shell = 'NOGIT=1 zsh'

" Prettier borders
let g:floaterm_borderchars = '─│─│╭╮╯╰'


" =============================================================================
" markdown-preview
" =============================================================================
let g:mkdp_auto_close = 0


" =============================================================================
" editorconfig-vim
" =============================================================================
let g:EditorConfig_exclude_patterns = ['fugitive://.*'] " for compatibility with vim-fugitive


" =============================================================================
" lualine
" =============================================================================
lua <<EOF
local function my_location()
  local data = [[%3l/%L]]
  return data
end

local function my_filename()
  local data = vim.fn.expand('%:~:.')
  return data
end

require('lualine').setup{
  sections = {
    lualine_a = { {'mode', upper = true} },
    lualine_b = { {'branch'} },
    lualine_c = { my_filename },
    lualine_z = { my_location },
  },
}
EOF


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

" One function for one colorscheme
" I could reuse some parts, but I cannot care less.
function! GruvboxMaterial()
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
  highlight! Search     cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
  highlight! IncSearch  cterm=reverse ctermfg=208 ctermbg=235 gui=reverse guifg=#fe8019 guibg=#282828

  " Vimdiff (from gruvbox-community)
  highlight! DiffText   cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
  highlight! DiffAdd    cterm=reverse ctermfg=142 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
  highlight! DiffDelete cterm=reverse ctermfg=167 ctermbg=235 gui=reverse guifg=#fb4934 guibg=#282828

  " Current line number (fg from Yellow, bg from CursorLine)
  call CopyFrom('CursorLineNr', 'Yellow',     'ctermfg', 1)
  call CopyFrom('CursorLineNr', 'CursorLine', 'ctermbg', 0)
  call CopyFrom('CursorLineNr', 'Yellow',     'guifg',   0)
  call CopyFrom('CursorLineNr', 'CursorLine', 'guibg',   0)
endfunction

function! Plain()
  colorscheme plain

  hi! link LspDiagnosticsDefaultError Constant
  hi! link LspDiagnosticsDefaultWarning Constant
  hi! link LspDiagnosticsDefaultInformation Constant
  hi! link LspDiagnosticsDefaultHint Constant

  let g:airline_theme = 'gruvbox_material'

  " Search matches (from gruvbox-community)
  highlight! Search     cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
  highlight! IncSearch  cterm=reverse ctermfg=208 ctermbg=235 gui=reverse guifg=#fe8019 guibg=#282828

  " Vimdiff (from gruvbox-community)
  highlight! DiffText   cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
  highlight! DiffAdd    cterm=reverse ctermfg=142 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
  highlight! DiffDelete cterm=reverse ctermfg=167 ctermbg=235 gui=reverse guifg=#fb4934 guibg=#282828

  " Sneak (from gruvbox-material)
  highlight! link Sneak Search
  highlight! link SneakLabel Search
  highlight! link SneakScope DiffText
endfunction

function! Base16()
  let base16colorspace=256
  colorscheme base16-gruvbox-dark-hard
  " colorscheme base16-default-dark

  highlight! link VertSplit SignColumn
  highlight! LineNR NONE
  highlight! CursorLineNr NONE
  highlight! SignColumn NONE
  highlight! Error NONE

  " Sneak (from gruvbox-material)
  highlight! link Sneak Search
  highlight! link SneakLabel Search
  highlight! link SneakScope DiffText

  " Transparent background
  highlight Normal guibg=NONE

  " Make comment more visible
  highlight Comment guifg=#80756c

  " Floaterm transparent border background
  autocmd VimEnter * highlight! FloatermBorder guibg=NONE
endfunction

" call Plain()
" call GruvboxMaterial()
call Base16()


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
if argc() > 0 && &diff == 0 && &columns > 125
  autocmd VimEnter * silent call NERDTreeToggleNoFocus()
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
let NERDTreeCustomOpenArgs={'file':{'reuse':'currenttab','where':'p','keepopen':1,'stay':0}}


" =============================================================================
" Telescope.nvim
" =============================================================================
" Mappings. live_grep uses rg by default.
nnoremap <Leader>f  :Telescope find_files<CR>
nnoremap <Leader>b  :Telescope buffers<CR>
nnoremap <Leader>gc :Telescope git_bcommits<CR>
nnoremap gs         :Telescope live_grep<CR>

lua << END
local action_state = require('telescope.actions.state')
function preview_scroll_up_one(prompt_bufnr)
  action_state.get_current_picker(prompt_bufnr).previewer:scroll_fn(-1)
end
function preview_scroll_down_one(prompt_bufnr)
  action_state.get_current_picker(prompt_bufnr).previewer:scroll_fn(1)
end

local actions = require'telescope.actions'
require'telescope'.setup{
  defaults = {
    mappings = {
      n = {
        ["H"]     = false,
        ["L"]     = false,
        ["<C-c>"] = actions.close,
        ["<C-y>"] = preview_scroll_up_one,
        ["<C-e>"] = preview_scroll_down_one,
      },
      i = {
        ["<C-c>"] = actions.close,
        ["<C-g>"] = actions.file_tab,
        ["<C-y>"] = preview_scroll_up_one,
        ["<C-e>"] = preview_scroll_down_one,
        ["<C-v>"] = actions.select_vertical,
        ["<C-s>"] = actions.select_horizontal,
      }
    }
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = true,
      override_file_sorter = true,
    }
  }
}

require'telescope'.load_extension('fzy_native')
END


" =============================================================================
" vim-rooter
" =============================================================================
let g:rooter_patterns = ['.git']


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
nnoremap <silent> gd :Telescope lsp_definitions<CR>
nnoremap <silent> gr :Telescope lsp_references<CR>
nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gw :lua require'telescope.builtin'.lsp_workspace_symbols{query = vim.fn.input("Query: ")}<CR>
nnoremap <silent> gD :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> gn :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> gp :lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ga :Telescope lsp_code_actions<CR>

lua << END
local lspconfig = require'lspconfig'
local on_attach = function(client)
  require'completion'.on_attach(client)
end

if vim.fn.executable('ccls') == 1 then
  lspconfig.ccls.setup{
    on_attach = on_attach,
    init_options = {
      client = { snippetSupport = false }
    }
  }
  vim.cmd('autocmd FileType c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType c,cpp setlocal signcolumn=yes')
end

if vim.fn.executable('pyright') == 1 then
  lspconfig.pyright.setup{
    on_attach = on_attach,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        }
      }
    }
  }
  vim.cmd('autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType python setlocal signcolumn=yes')
end

if vim.fn.executable('pyls') == 0 then
  lspconfig.pyls.setup{
    on_attach = on_attach,
    settings = {
      pyls = {plugins = {pycodestyle = {ignore = {"E501"}}}}
    }
  }
  vim.cmd('autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType python setlocal signcolumn=yes')
end

if vim.fn.executable('dotnet') == 0 then
  lspconfig.pyls_ms.setup{
    on_attach = on_attach,
    cmd = {
      "dotnet",
      "exec",
      -- NOTE: linked with path and mspyls.sh
      vim.fn.expand("~") .. "/.local/src/python-language-server/output/bin/Debug/Microsoft.Python.LanguageServer.dll"
    },
  }
  vim.cmd('autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType python setlocal signcolumn=yes')
end

-- Configs for diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Virtual text appearance
    virtual_text = {
      spacing = 4,
    },
    -- Do not update in insert mode
    update_in_insert = true,
  }
)
END

" Use tab to bring up and traverse completion list
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

set completeopt=menuone,noinsert,noselect
set shortmess+=c


" =============================================================================
" rust-tools.nvim
" =============================================================================
lua << END
require'rust-tools'.setup {
  tools = {
    inlay_hints = {
      show_parameter_hints = false,
      other_hints_prefix = '  » ',
    }
  },
  server = {
    on_attach = require'completion'.on_attach,
    settings = {
      ["rust-analyzer"] = {
        completion = {
          addCallArgumentSnippets = false,
          addCallParenthesis = false,
        },
        diagnostics = {
          disabled = {"inactive-code"},
        },
      },
    },
  },
}
END
autocmd FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd FileType rust setlocal signcolumn=yes


" =============================================================================
" nvim-treesitter
" =============================================================================
lua << END
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "python" },
  highlight = {
    enable = true,
  },
}
END


" =============================================================================
" Must-be-done-at-the-end config
" =============================================================================
set secure exrc                 " Execute .vimrc in the directory vim is started
