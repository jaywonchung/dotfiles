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
set diffopt+=algorithm:patience " Use the patience algorithm
set diffopt+=indent-heuristic   " Internal diff lib for indents
" appearance
set showmatch                   " Highlight matching braces
set background=dark             " Dark background
set number relativenumber       " Show relative line number
set noshowmode                  " Do not show current mode at the bottom
set cursorline                  " Highlight the row where the cursor is on
" misc
set mouse=a                     " Mouse is useful for visual selection
set history=256                 " History for commands, searches, etc

" Embed lua syntax highlighting in vimscript
let g:vimsyn_embed = 'l'

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

" Edit config
command Nconf tabe ~/.config/nvim/init.vim


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
nnoremap <Leader>qq :q<CR>
nnoremap <Leader>qa :qa<CR>
nnoremap <Leader>s :sp<CR>
nnoremap <Leader>v :vsp<CR>
nnoremap <Leader>p :echo expand('%:p')<CR>

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
nnoremap <Leader>du :diffupdate<CR>
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

" Consistency with C and D
nnoremap Y y$

" Keeping things centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Undo breakpoints
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

" Ups and downs farther than 5 lines adds to the jump list
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Delete one character in insert mode
inoremap <C-d> <DEL>


" =============================================================================
" Autocommands
" =============================================================================
" Pick up where I left off
autocmd BufReadPost *
  \   if ! &diff && line("'\"") > 0 && line("'\"") <= line("$")
  \ |   exe "norm g`\""
  \ | endif

" Fix autoread
autocmd FocusGained,BufEnter * :checktime

" Resize splits when vim size changes
autocmd VimResized * wincmd =

" Turn off row numbers when window is small
autocmd VimResized *
  \   if &columns < 75
  \ |   set nonumber norelativenumber
  \ | endif
autocmd VimResized *
  \   if &columns >= 75
  \ |   set number relativenumber
  \ | endif

" Highlight yanked text
autocmd TextYankPost * lua require'vim.highlight'.on_yank({"Substitute", 300})

" Restore cursor shape when exiting
autocmd VimEnter,VimResume * set guicursor=n-v:block-Cursor/lCursor-blinkon0,i-c-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
autocmd VimLeave,VimSuspend * set guicursor=a:ver25

" Set line wrap for both splits for vimdiff
autocmd VimEnter * if &diff | execute 'windo set wrap' | endif


" =============================================================================
" Language settings
" =============================================================================
" Verilog
autocmd FileType verilog setlocal shiftwidth=4 tabstop=4 softtabstop=4

" Rust
autocmd FileType rust setlocal shiftwidth=4 tabstop=4 softtabstop=4

" Go
autocmd FileType go setlocal shiftwidth=8 tabstop=8 softtabstop=8

" LaTeX
let g:tex_flavor = "latex"

" Lua filetypes
let g:do_filetype_lua = 1
let g:did_load_filetypes = 0


" =============================================================================
" Plugins
" =============================================================================
call plug#begin(stdpath('data') . '/plugged')
" performance
Plug 'lewis6991/impatient.nvim'
" editing
Plug 'editorconfig/editorconfig-vim'
Plug 'numToStr/Comment.nvim'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-repeat'
Plug 'foosoft/vim-argwrap'
Plug 'ojroques/nvim-osc52'
Plug 'voldikss/vim-floaterm'
Plug 'zbirenbaum/copilot.lua'
Plug 'debugloop/telescope-undo.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
" appearance
Plug 'hoob3rt/lualine.nvim'
Plug 'sainnhe/gruvbox-material'
Plug 'chriskempson/base16-vim'
Plug 'andreypopp/vim-colors-plain'
Plug 'tpope/vim-markdown'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'jaywonchung/nvim-tundra'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
" git integration
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
" navigation
Plug 'kyazdani42/nvim-tree.lua'
Plug 'stevearc/oil.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'airblade/vim-rooter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ggandor/lightspeed.nvim'
" language server protocol
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'ray-x/lsp_signature.nvim'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'simrat39/rust-tools.nvim'
Plug 'j-hui/fidget.nvim', {'tag': 'legacy'}
Plug 'L3MON4D3/luasnip'
Plug 'RRethy/vim-illuminate'
Plug 'liuchengxu/vista.vim'
" syntactic language support
Plug 'rust-lang/rust.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'lervag/vimtex'
call plug#end()

" =============================================================================
" impatient.nvim
" =============================================================================
lua require'impatient'


" =============================================================================
" indent-blankline.nvim
" =============================================================================
lua <<END
require'ibl'.setup{
  scope = { enabled = false },
  indent = { char = '┋', highlight = { "LineNr" } },
}
END


" =============================================================================
" editorconfig-vim
" =============================================================================
let g:EditorConfig_verbose = 1


" =============================================================================
" comment.nvim
" =============================================================================
lua require'Comment'.setup()


" =============================================================================
" vim-sandwich
" =============================================================================
runtime macros/sandwich/keymap/surround.vim


" =============================================================================
" vim-argwrap
" =============================================================================
let g:argwrap_tail_comma = 1

nnoremap <Leader>aw :ArgWrap<CR>


" =============================================================================
" nvim-osc52
" =============================================================================
lua <<END
vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, {expr = true})
vim.keymap.set('n', '<leader>yy', '<leader>y_', {remap = true})
vim.keymap.set('v', '<leader>y', require('osc52').copy_visual)
END


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

" Disable git plugin inside floaterm
let g:floaterm_shell = 'zsh'

" Prettier borders
let g:floaterm_borderchars = '─│─│╭╮╯╰'

" Silently start a terminal in the background so that it's quick when we want
" the terminal
autocmd VimEnter * FloatermNew --silent


" =============================================================================
" copilot.lua
" =============================================================================
lua <<END
require"copilot".setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<C-e>",  -- Doesn't conflict with cmp because select = false.
      accept_line = "<M-e>",
    },
  },
  filetypes = {
    python = true,
    rust = true,
    ["*"] = false,
  }
})
END


" =============================================================================
" editorconfig-vim
" =============================================================================
let g:EditorConfig_exclude_patterns = ['fugitive://.*'] " for compatibility with vim-fugitive


" =============================================================================
" fugitive
" =============================================================================
nnoremap <Leader>gs :G<CR>
nnoremap <Leader>gb :Git blame<CR>
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

  let g:lualine_theme = 'gruvbox-material'

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

  let g:lualine_theme = 'gruvbox-material'

  " Search matches (from gruvbox-community)
  highlight! Search     cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
  highlight! IncSearch  cterm=reverse ctermfg=208 ctermbg=235 gui=reverse guifg=#fe8019 guibg=#282828

  " Vimdiff (from gruvbox-community)
  highlight! DiffText   cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
  highlight! DiffAdd    cterm=reverse ctermfg=142 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
  highlight! DiffDelete cterm=reverse ctermfg=167 ctermbg=235 gui=reverse guifg=#fb4934 guibg=#282828
endfunction

function! Base16()
  let base16colorspace=256
  colorscheme base16-gruvbox-dark-hard
  " colorscheme base16-default-dark

  let g:lualine_theme = 'gruvbox-material'

  highlight! link VertSplit SignColumn
  highlight! LineNR NONE
  highlight! CursorLineNr NONE
  highlight! SignColumn NONE
  highlight! Error NONE

  " Transparent background
  highlight Normal guibg=NONE

  " Make comment more visible
  highlight Comment guifg=#80756c

  " Lsp diagnostics
  highlight LspDiagnosticsVirtualTextHint        gui=italic guifg=LightGray
  highlight LspDiagnosticsVirtualTextInformation gui=italic guifg=LightBlue
  highlight LspDiagnosticsVirtualTextWarning     gui=italic guifg=Orange
  highlight LspDiagnosticsVirtualTextError       gui=italic guifg=Red

  " Floaterm transparent border background
  autocmd VimEnter * highlight! FloatermBorder guibg=NONE
endfunction

function! Nightfly() 
  let g:nightflyTransparent = 1

  colorscheme nightfly

  let g:lualine_theme = 'nightfly'

  " Enhancements
  highlight! VertSplit None

  " Vimdiff (from gruvbox-community)
  highlight! DiffText   cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
  highlight! DiffAdd    cterm=reverse ctermfg=142 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
  highlight! DiffDelete cterm=reverse ctermfg=167 ctermbg=235 gui=reverse guifg=#fb4934 guibg=#282828

  " nvim-tree
  highlight! NvimTreeNormal guibg=NONE
endfunction

function! Tundra() 
lua <<END
require'nvim-tundra'.setup({
  transparent_background = true,
  syntax = {
    comments = { italic = true },
    booleans = { italic = true },
    types = { italic = true },
  },
  plugins = {
    lsp = true,
    treesitter = true,
    cmp = true,
    gitsigns = true,
  },
})
END

  colorscheme tundra

  let g:lualine_theme = 'tundra'

  " Enhancements
  highlight! link VertSplit SignColumn

  " Cursor line (from nightfly)
  highlight! CursorLine guibg=#092236

  " Vimdiff (from gruvbox-community)
  highlight! DiffText   cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
  highlight! DiffAdd    cterm=reverse ctermfg=142 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
  highlight! DiffDelete cterm=reverse ctermfg=167 ctermbg=235 gui=reverse guifg=#fb4934 guibg=#282828

  " vim-illuminate
  highlight link LspReferenceText CursorLine
  highlight link LspReferenceRead CursorLine
  highlight link LspReferenceWrite CursorLine
endfunction

function! Catppuccin() 
lua <<END
require"catppuccin".setup({
  transparent_background = true,
  styles = {
    conditionals = {},
  },
  integrations = {
    cmp = true,
    fidget = true,
    native_lsp = {
      enabled = true,
    },
  },
})
END

  colorscheme catppuccin-mocha

  " Cursor line (from nightfly)
  highlight! CursorLine guibg=#092236

  let g:lualine_theme = "catppuccin"

  " LSP hover menu dark background (from Tundra)
  highlight  NormalFloat guibg=#0e1420
  " nvim-cmp autocompletion menu
  highlight  Pmenu       guibg=#0e1420
endfunction

" call Plain()
" call GruvboxMaterial()
" call Base16()
" call Nightfly()
" call Tundra()
call Catppuccin()


" =============================================================================
" lualine
" =============================================================================
" NOTE: Depends on g:lualine_theme being set in the 'colorscheme' section.
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
  options = {
    theme = vim.g.lualine_theme
  },
  sections = {
    lualine_a = { { 'mode', upper = true } },
    lualine_b = { { 'branch' } },
    lualine_c = { { my_filename } },
    lualine_z = { { my_location } },
  },
}
EOF


" =============================================================================
" vim-markdown
" =============================================================================
" Syntax highlighting for code embedded in markdown
let g:markdown_fenced_languages = ["python", "sh", "bash=sh"]


" =============================================================================
" gitsigns.nvim
" =============================================================================
lua require'gitsigns'.setup{}


" =============================================================================
" vista.vim
" =============================================================================
let g:vista_default_executive = 'nvim_lsp'
let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista_blink = [0, 0]
let g:vista_top_level_blink = [0, 0]
let g:vista_no_mappings = 1

nnoremap <silent> <Leader>t :Vista!!<CR>
autocmd FileType vista,vista_kind
    \ nnoremap <buffer> <silent> <CR> :call vista#cursor#FoldOrJump()<CR>


" =============================================================================
" nvim-tree.lua
" =============================================================================
nnoremap <silent> <C-f> :lua require'nvim-tree.api'.tree.open({focus = true, find_file = true})<CR>

nnoremap <silent> <Leader>n :lua require'nvim-tree.api'.tree.toggle(true, true)<CR>

lua <<END
-- Open-At-Startup configuration
local function open_nvim_tree(data)

  -- Buffer is a real file on the disk -> open
  local real_file = vim.fn.filereadable(data.file) == 1

  -- Buffer is a [No Name] -> don't open
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- Currently in diff mode (nvim -d) -> don't open
  local diff_mode = vim.opt.diff:get()

  -- Neovim is wide enough -> open
  local wide_enough = vim.opt.columns:get() > 125

  if not real_file or no_name or diff_mode or not wide_enough then
    return
  end

  -- open the tree, find the file, but don't focus nvim-tree
  require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Default mappings.
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
  vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
  vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
  vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
  vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
  vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
  vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
  vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
  vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
  vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
  vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
  vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
  vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
  vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
  vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
  vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
  vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
  vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
  vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
  vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
  vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
  vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
  vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
  vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
  vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
  vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
  vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
  vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
  vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
  vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
  vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
  vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
  vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))

  -- Mappings migrated from view.mappings.list
  vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<C-g>', api.node.open.tab, opts('Open: New Tab'))
  vim.keymap.set('n', '<F2>', api.fs.rename, opts('Rename'))
end

require'nvim-tree'.setup({
  on_attach = on_attach,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  open_on_tab = true,
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      }
    },
  },
})
END

function! NvimTreeAutoQuit()
  " If nvim-tree is the only window left, close it.
  if winnr("$") == 1
    if bufname() == 'NvimTree_' . tabpagenr()
      q
    endif
  " Even when there are more than one windows, we want to ignore
  " floating windows.
  else
    for winid in nvim_list_wins()
      " The existence of a window that is not nvim-tree and is not floating
      " means that we cannot quit everything.
      if bufname(nvim_win_get_buf(winid)) != 'NvimTree_' . tabpagenr()
        if !has_key(nvim_win_get_config(winid), 'zindex')
          return
        endif
      endif
    endfor
    qa
  endif
endfunction
autocmd BufEnter * silent call NvimTreeAutoQuit()


" =============================================================================
" oil.nvim
" =============================================================================
lua <<END
require'oil'.setup({
  keymaps = {
    ["<C-s>"] = "actions.select_split",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-g>"] = "actions.select_tab",
  },
})
END


" =============================================================================
" Telescope.nvim
" =============================================================================
" Mappings. live_grep uses rg by default.
nnoremap <silent> <Leader>f  :Telescope find_files find_command=fd,.,-H,--ignore-file,.gitignore,--exclude,.git,--type,f<CR>
nnoremap <silent> <Leader>b  :Telescope buffers<CR>
nnoremap <silent> <Leader>gc :Telescope git_bcommits<CR>
nnoremap <silent> <Leader>u  :Telescope undo<CR>
if executable("rg")
  nnoremap gs       :Telescope live_grep<CR>
else
  echom "RipGrep (rg) is not installed. Disabling Telescope live_grep."
endif

lua << END
local action_state = require('telescope.actions.state')
function preview_scroll_up_one(prompt_bufnr)
  action_state.get_current_picker(prompt_bufnr).previewer:scroll_fn(-1)
end
function preview_scroll_down_one(prompt_bufnr)
  action_state.get_current_picker(prompt_bufnr).previewer:scroll_fn(1)
end

local actions = require'telescope.actions'
local config = require'telescope.config'

require'telescope'.setup{
  defaults = {
    mappings = {
      n = {
        ["H"]     = false,
        ["L"]     = false,
        ["<C-c>"] = actions.close,
        ["<C-y>"] = preview_scroll_up_one,
        ["<C-e>"] = preview_scroll_down_one,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
      },
      i = {
        ["<C-c>"] = actions.close,
        ["<C-g>"] = actions.file_tab,
        ["<C-y>"] = preview_scroll_up_one,
        ["<C-e>"] = preview_scroll_down_one,
        ["<C-v>"] = actions.select_vertical,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<ESC>"] = actions.close,
      }
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--ignore-file",
      ".gitignore",
      "--glob",
      "!.git",
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = true,
      override_file_sorter = true,
    },
    undo = {
      use_delta = (vim.fn.executable("delta") == 1),
      side_by_side = (vim.fn.executable("delta") == 1),
      layout_strategy = "vertical",
    },
  },
}

require'telescope'.load_extension('fzy_native')
require'telescope'.load_extension('undo')
END


" =============================================================================
" vim-rooter
" =============================================================================
let g:rooter_patterns = ['.git', 'Cargo.toml']


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
nnoremap <silent> gD :lua vim.diagnostic.open_float()<CR>
nnoremap <silent> gn :lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> gp :lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ga :lua vim.lsp.buf.code_action()<CR>

lua << END
local cmp = require'cmp';
local luasnip = require'luasnip';

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line-1, line, true)[1]:sub(col, col):match("%s") == nil
end
local tab_function = function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end
local stab_function = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

cmp.setup({
  snippet = {
    expand = function(arg)
      luasnip.lsp_expand(arg.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping(cmp.mapping.confirm({ select = false })),
    ['<C-f>'] = cmp.mapping(cmp.mapping.close(), { 'i', 's' }),
    ['<Tab>'] = cmp.mapping(tab_function, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(stab_function, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
  },
  preselect = cmp.PreselectMode.None,
})

require("luasnip.loaders.from_vscode").load()

require'lsp_signature'.setup({ hint_prefix = "@" })

local lspconfig = require'lspconfig'
local capabilities = require'cmp_nvim_lsp'.default_capabilities()

if vim.fn.executable('clangd') == 1 then
  lspconfig.clangd.setup{
    on_attach = require'illuminate'.on_attach,
    capabilities = capabilities,
  }
  vim.cmd('autocmd FileType c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd FileType c,cpp setlocal signcolumn=yes')
end

if vim.fn.executable('pyright') == 1 then
  lspconfig.pyright.setup{
    on_attach = require'illuminate'.on_attach,
    capabilities = capabilities,
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

if vim.fn.executable('texlab') == 1 then
  lspconfig.texlab.setup{
    on_attach = require'illuminate'.on_attach,
    capabilities = capabilities,
    settings = {
      texlab = {
        chktex = {
          onEdit = true,
        }
      }
    }
  }
end

if vim.fn.executable('ltex-ls') == 1 then
  local ltex_config = { dictionary = { ["en-US"] = {} } }
  -- My custom dictionary is inside `~/.local/ltex/config.lua`.
  if vim.fn.filereadable(os.getenv("HOME") .. "/.config/ltex/config.lua") == 1 then
    ltex_config = loadfile(os.getenv("HOME") .. "/.config/ltex/config.lua")()
  end
  --[[
  If the current directory has a `.ltex_dictionary.lua` file, add it to the custom dictionary.
  It should looke like this:
  ```lua
  return {
    "Jae-Won",
    "ltex".
  }
  ```
  --]]
  if vim.fn.filereadable('.ltex_dictionary.lua') == 1 then
    endict = ltex_config['dictionary']['en-US']
    for _, v in ipairs(loadfile('.ltex_dictionary.lua')()) do
      table.insert(endict, v)
    end
  end
  lspconfig.ltex.setup{
    on_attach = require'illuminate'.on_attach,
    capabilities = capabilities,
    settings = {
      ltex = ltex_config,
    }
  }
end

if vim.fn.executable('texlab') == 1 then
  lspconfig.texlab.setup{
    on_attach = require'illuminate'.on_attach,
    capabilities = capabilities,
    settings = {
      texlab = {
        chktex = {
          onEdit = true,
          onOpenAndSave = true,
        },
      },
    },
  }
end

if vim.fn.executable('gopls') == 1 then
  lspconfig.gopls.setup{
    on_attach = require'illuminate'.on_attach,
    capabilities = capabilities,
  }
end

if vim.fn.executable('zls') == 1 then
  lspconfig.zls.setup{
    on_attach = require'illuminate'.on_attach,
    capabilities = capabilities,
  }
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

set completeopt=menuone,noinsert,noselect
set shortmess+=c

lua << END
require'fidget'.setup {
  text = { spinner = "dots" },
  window = { blend = 0 },
}
END


" =============================================================================
" rust-tools.nvim
" =============================================================================
lua << END
local capabilities = require'cmp_nvim_lsp'.default_capabilities()

require'rust-tools'.setup {
  tools = {
    inlay_hints = {
      show_parameter_hints = true,
      other_hints_prefix = '  » ',
    }
  },
  server = {
    capabilities = capabilities,
    on_attach = require'illuminate'.on_attach,
    settings = {
      ["rust-analyzer"] = {
        completion = {
          addCallArgumentSnippets = true,
          addCallParenthesis = true,
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
  ensure_installed = { "c", "cpp", "python", "rust", "go", "vim", "lua" },
  highlight = {
    enable = true,
  },
}
require'treesitter-context'.setup()
END


" =============================================================================
" vimtex
" =============================================================================
let g:vimtex_view_method = 'sioyek'
let g:vimtex_view_sioyek_exe = '/Applications/sioyek.app/Contents/MacOS/sioyek'
let g:vimtex_view_use_temp_files = 1
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_enabled = 1
let g:vimtex_imaps_enabled = 0
let g:vimtex_quickfix_autoclose_after_keystrokes = 4
let g:vimtex_toc_enabled = 0
let g:vimtex_view_reverse_search_edit_cmd = 'tabedit'
let g:vimtex_quickfix_ignore_filters = [
      \ 'warning',
      \ 'Warning',
      \ 'Missing "school"',
      \ 'no output PDF',
      \ 'Underfull',
      \ 'overfull',
      \]
let maplocalleader=','
