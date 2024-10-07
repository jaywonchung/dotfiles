------------------------------------------------------------------------------
-- General and Miscellaneous
------------------------------------------------------------------------------
-- Experimental lua loader for fast startup time
if vim.loader then
  vim.loader.enable()
end

-- Options
vim.opt.autoindent = true           -- Insert indent on newline
vim.opt.cindent = true              -- Autoindent for C
vim.opt.smartindent = true          -- Aware of {, }, etc
vim.opt.scrolloff = 2               -- Lines between cursor and screen
vim.opt.softtabstop = 2             -- Width of <tab>
vim.opt.tabstop = 2                 -- Width of interpretation of <tab>
vim.opt.shiftwidth = 2              -- Width of >> and <<
vim.opt.expandtab = true            -- <Tab> to spaces, <C-v><Tab> for real tab
vim.opt.smarttab = true             -- <Tab> at line start obeys shiftwidth
vim.opt.backspace = { "eol", "start", "indent" }  -- Backspace same as other programs
vim.opt.listchars = { extends = "›", nbsp = "·", precedes = "‹", tab = "» ", trail = "·" }  -- invisible chars
vim.opt.wildmenu = true             -- Command mode autocompletion list
vim.opt.wildmode = { "longest:full", "full" }  -- <Tab> spawns wildmenu, then <Tab> to cycle list
vim.opt.ignorecase = true           -- Case-insensitive search
vim.opt.smartcase = true            -- ... except when uppercase characters are typed
vim.opt.incsearch = true            -- Search as I type
vim.opt.hidden = true               -- Allow switching to other buffers without saving
vim.opt.autoread = true             -- Auto load when current file is edited somewhere
vim.opt.lazyredraw = true           -- Screen not updated during macros, etc
vim.opt.diffopt:append("algorithm:patience")  -- Use the patience algorithm
vim.opt.diffopt:append("indent-heuristic")    -- Internal diff lib for indents
vim.opt.showmatch = true            -- Highlight matching braces
vim.opt.background = dark           -- Dark background
vim.opt.number = true               -- Show line number
vim.opt.relativenumber = true       -- Line numbers are relative to current line
vim.opt.showmode = false            -- Do not show current mode at the bottom
vim.opt.cursorline = true           -- Highlight the row where the cursor is on
vim.opt.signcolumn = "yes"          -- Space for LSP diagnostics and gitsigns
vim.opt.mouse = { a = true }        -- Mouse is useful for visual selection
vim.opt.history = 256               -- History for commands, searches, etc

-- Syntax highlighting
vim.cmd('syntax on')

-- Persistent undo
local undodir = vim.fn.stdpath('data') .. '/undodir'
vim.opt.undodir = undodir
vim.opt.undofile = true
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

------------------------------------------------------------------------------
-- Key mappings
------------------------------------------------------------------------------
-- Leader keys
vim.g.maplocalleader = ','
vim.g.mapleader = " "

-- Cursor movement
vim.keymap.set({ 'n', 'v' }, 'H', '^')
vim.keymap.set({ 'n', 'v' }, 'L', '$')
vim.keymap.set('n', ';', ':')

-- Suspend vim
vim.keymap.set('n', '<C-z>', ':suspend<CR>')

-- Unhighlight all search highlights
vim.keymap.set('n', '<C-c>', ':noh<CR>', { silent = true })

-- Toggle relative line numbers
vim.keymap.set('n', '<Leader>r', function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { silent = true })

-- Windows and files
vim.keymap.set('n', '<Leader>w', ':w<CR>')
vim.keymap.set('n', '<Leader>qq', ':q<CR>')
vim.keymap.set('n', '<Leader>qa', ':qa<CR>')
vim.keymap.set('n', '<Leader>s', ':sp<CR>')
vim.keymap.set('n', '<Leader>v', ':vsp<CR>')
vim.keymap.set('n', '<Leader>p', ":echo expand('%:p')<CR>")

-- Delete selected area and replace with yanked content
-- without overwriting the copy register "
vim.keymap.set('v', '<Leader>p', '"_dP')

-- <C-c> and <ESC> are not the same
vim.keymap.set({ 'i', 'v' }, '<C-c>', '<ESC>')

-- Automatically closing brackets
vim.keymap.set('i', '{<CR>', '{<CR>}<ESC>O')

-- Surrounding with brackets
vim.keymap.set('n', '(<CR>', 'i(<CR><ESC>o)<ESC>k^')
vim.keymap.set('n', '{<CR>', 'i{<CR><ESC>o}<ESC>k^')
vim.keymap.set('n', '[<CR>', 'i[<CR><ESC>o]<ESC>k^')

-- Diff mappings
vim.keymap.set('n', '<Leader>dg', ':diffget<CR>')
vim.keymap.set('n', '<Leader>dp', ':diffput<CR>')
vim.keymap.set('n', '<Leader>du', ':diffupdate<CR>')
vim.keymap.set('n', '<Leader>gh', ':diffget //2<CR>')
vim.keymap.set('n', '<Leader>gl', ':diffget //3<CR>')

-- * and # obey smartcase
--
-- e.g.
--              | foo  fool  Foo  Fool
--  ------------|-----------------------
--   *  on foo  |  v          v
--   *  on fool |        v          v
--   *  on Foo  |             v
--   *  on Fool |                   v
--  ------------|-----------------------
--   g* on foo  |  v     v    v     v
--   g* on fool |        v          v
--   g* on Foo  |             v     v
--   g* on Fool |                   v
vim.cmd([[
nnoremap <silent> * :let @/='\v<'.expand('<cword>').'>'<CR>:let v:searchforward=1<CR>n
nnoremap <silent> # :let @/='\v<'.expand('<cword>').'>'<CR>:let v:searchforward=0<CR>n
nnoremap <silent> g* :let @/='\v'.expand('<cword>')<CR>:let v:searchforward=1<CR>n
nnoremap <silent> g# :let @/='\v'.expand('<cword>')<CR>:let v:searchforward=0<CR>n
]])

-- Neovim terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l')

-- Consistency with C and D
vim.keymap.set('n', 'Y', 'y$')

-- Keeping things centered
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'J', 'mzJ`z')

-- Undo breakpoints
vim.keymap.set('i', ',', ',<C-g>u')
vim.keymap.set('i', '.', '.<C-g>u')
vim.keymap.set('i', '!', '!<C-g>u')
vim.keymap.set('i', '?', '?<C-g>u')

-- Ups and downs farther than 5 lines adds to the jump list
vim.keymap.set('n', 'k', function()
  return (vim.v.count > 5 and "m'" .. vim.v.count or "") .. 'k'
end, { expr = true, silent = true })
vim.keymap.set('n', 'j', function()
  return (vim.v.count > 5 and "m'" .. vim.v.count or "") .. 'j'
end, { expr = true, silent = true })

-- Delete one character in insert mode
vim.keymap.set('i', '<C-d>', '<DEL>')


------------------------------------------------------------------------------
-- Autocommands
------------------------------------------------------------------------------
-- Pick up where I left off
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(opts)
    vim.api.nvim_create_autocmd("BufWinEnter", {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match('commit') and ft:match('rebase'))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})
-- Fix autoread
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime"
})

-- Resize splits when vim size changes
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "wincmd ="
})

-- Turn off row numbers when window is small
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  callback = function()
    if vim.o.columns < 75 then
      vim.opt.number = false
      vim.opt.relativenumber = false
    else
      vim.opt.number = true
      vim.opt.relativenumber = true
    end
  end
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    require('vim.highlight').on_yank({ higroup = 'Substitute', timeout = 300 })
  end
})

-- Cursor shape
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  pattern = "*",
  command = "set guicursor=n-v:block-Cursor/lCursor-blinkon0,i-c-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor"
})
vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  pattern = "*",
  command = "set guicursor=a:ver25"
})

-- Set line wrap for both splits when in diff mode
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    if vim.wo.diff then
      vim.cmd('windo set wrap')
    end
  end
})


------------------------------------------------------------------------------
-- Language settings
------------------------------------------------------------------------------
-- Go
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.shiftwidth = 8
    vim.bo.tabstop = 8
    vim.bo.softtabstop = 8
  end
})

-- LaTeX
vim.g.tex_flavor = "latex"

--- Lua filetypes
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

------------------------------------------------------------------------------
-- Plugins
------------------------------------------------------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  rocks = { enabled = false },
  spec = {
    -- Editing
    { "numToStr/Comment.nvim" },
    { "farmergreg/vim-lastplace" },
    { "tpope/vim-repeat" },
    {
      "machakann/vim-sandwich",
      init = function()
        vim.g.sandwich_no_default_key_mappings = 1
      end,
      config = function()
        vim.cmd('runtime macros/sandwich/keymap/surround.vim')
      end,
    },
    {
      "foosoft/vim-argwrap",
      init = function()
        vim.g.argwrap_tail_comma = 1
        vim.keymap.set('n', '<Leader>aw', ':ArgWrap<CR>')
      end,
    },
    {
      "ojroques/nvim-osc52",
      config = function()
        vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, { expr = true })
        vim.keymap.set('n', '<leader>yy', '<leader>y_', { remap = true })
        vim.keymap.set('v', '<leader>y', require('osc52').copy_visual)
      end,
    },
    {
      "voldikss/vim-floaterm",
      init = function()
        -- Size
        vim.g.floaterm_height = 0.7
        vim.g.floaterm_width = 0.7

        -- Close window when process exits
        vim.g.floaterm_autoclose = 2

        -- Open and hide.
        vim.keymap.set('n', '<CR>', ':FloatermToggle<CR>', { silent = true })
        vim.keymap.set('t', '<C-z>', '<C-\\><C-n>:FloatermHide<CR>', { silent = true })

        -- Default shell
        if vim.fn.executable('zsh') == 1 then
          vim.g.floaterm_shell = 'zsh'
        end

        -- Prettier borders
        vim.g.floaterm_borderchars = '─│─│╭╮╯╰'

        -- Silently start a terminal in the background at startup
        vim.api.nvim_create_autocmd("VimEnter", {
          pattern = "*",
          command = "FloatermNew --silent"
        })

        -- `floaterm [FILE]` inside the floating terminal will open the file as:
        vim.g.floaterm_opener = "tabe"
      end,
    },
    {
      "zbirenbaum/copilot.lua",
      config = function()
        require("copilot").setup({
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
            go = true,
            cpp = true,
            bash = true,
            zig = true,
            ["*"] = false,
          },
        })

        vim.keymap.set('n', '<Leader>cd', ':Copilot disable<CR>', { silent = true })
      end,
    },
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false, -- set this if you want to always pull the latest change
      opts = {
        -- add any opts here
      },
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",
      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "Avante" },
          },
          ft = { "Avante" },
        },
      },
      config = function()
        require('avante').setup({
          provider = "copilot"
        })
      end
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {
        scope = { enabled = false },
        indent = { char = '┋', highlight = { "LineNr" } },
      },
    },
    -- Appearance
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "mechatroner/rainbow_csv", ft = "csv" },
    {
      "hoob3rt/lualine.nvim",
      config = function()
        -- NOTE: Depends on g:lualine_theme being set when configuring the colorscheme.
        local function my_filename()
          return vim.fn.expand('%:~:.')
        end

        local function my_location()
          return [[%3l/%L]]
        end

        require('lualine').setup{
          options = {
            icons_enabled = false,
            theme = vim.g.lualine_theme
          },
          sections = {
            lualine_a = { { 'mode', upper = true } },
            lualine_b = { { 'branch' } },
            lualine_c = { { my_filename } },
            lualine_z = { { my_location } },
          },
        }
      end,
    },
    {
      "bluz71/vim-nightfly-guicolors",
      lazy = true,
      priority = 1000,
      config = function()
        vim.g.nightflyTransparent = 1

        vim.cmd('colorscheme nightfly')

        vim.g.lualine_theme = 'nightfly'

        vim.cmd([[
        " Enhancements
        highlight! VertSplit None

        " Vimdiff (from gruvbox-community)
        highlight! DiffText   cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828
        highlight! DiffAdd    cterm=reverse ctermfg=142 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
        highlight! DiffDelete cterm=reverse ctermfg=167 ctermbg=235 gui=reverse guifg=#fb4934 guibg=#282828

        " nvim-tree
        highlight! NvimTreeNormal guibg=NONE
        ]])
      end
    },
    {
      "jaywonchung/nvim-tundra",
      lazy = true,
      priority = 1000,
      config = function()
        require('nvim-tundra').setup({
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

        vim.cmd('colorscheme tundra')

        vim.g.lualine_theme = 'tundra'

        vim.cmd([[
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
        ]])
      end
    },
    {
      "catppuccin/nvim",
      name = 'catppuccin',
      lazy = false,
      priority = 1000,
      config = function()
        require("catppuccin").setup({
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

        vim.g.lualine_theme = "catppuccin"

        vim.cmd([[
        colorscheme catppuccin-mocha

        " Make comments slightly lighter
        highlight  Comment     guifg=#81859a

        " Cursor line (from nightfly)
        highlight! CursorLine  guibg=#092236

        " LSP hover menu dark background (from Tundra)
        highlight  NormalFloat guibg=#0e1420
        " nvim-cmp autocompletion menu
        highlight  Pmenu       guibg=#0e1420
        
        " diffview.nvim
        highlight  DiffviewFilePanelTitle   guifg=#74c7ed
        highlight  DiffviewFilePanelCounter guifg=#74c7ed
        ]])
      end
    },
    {
      "projekt0n/github-nvim-theme",  -- Really just for screenshot purposes.
      lazy = true,
      priority = 1000,
      config = function()
        vim.g.lualine_theme = "github_light"
        vim.cmd([[
        colorscheme github_light
        highlight Normal guibg=#f6f8fa
        ]])
      end
    },
    -- Git integration
    { "lewis6991/gitsigns.nvim", config = true },
    {
      "tpope/vim-fugitive",
      keys = {
        { '<Leader>gb', ':Git blame<CR>', desc = "Fugitive git blame" },
      },
    },
    {
      "sindrets/diffview.nvim",
      opts = {
        enhanced_diff_hl = true,
      },
    },
    -- Navigation
    {
      "kyazdani42/nvim-tree.lua",
      config = function()
        -- Keymaps
        vim.keymap.set('n', '<C-f>', function()
          require("nvim-tree.api").tree.open({ focus = true, find_file = true })
        end, { silent = true })
        vim.keymap.set('n', '<Leader>n', function()
          require("nvim-tree.api").tree.toggle(true, true)
        end, { silent = true })

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
          renderer = {
            icons = { show = { file = false } },
          },
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

        -- Close all nvim-tree windows when it's closed.
        -- Also, while ignoring fidget.nvim windows, if the last code window was closed, quit Neovim.
        local function tab_win_closed(winnr)
          local api = require"nvim-tree.api"
          local tabnr = vim.api.nvim_win_get_tabpage(winnr)
          local bufnr = vim.api.nvim_win_get_buf(winnr)
          local buf_info = vim.fn.getbufinfo(bufnr)[1]
          local all_tab_wins = vim.api.nvim_tabpage_list_wins(tabnr)
          local remaining_wins = vim.tbl_filter(function(w) return w ~= winnr end, all_tab_wins)
          local remaining_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, remaining_wins)

          local significant_remaining_bufs = vim.tbl_filter(function(b)
            local info = vim.fn.getbufinfo(b)[1]
            return vim.bo[info.bufnr].filetype ~= "fidget"
          end, remaining_bufs)

          if buf_info.name:match(".*NvimTree_%d*$") then
            if not vim.tbl_isempty(significant_remaining_bufs) then
              api.tree.close()
            end
          else
            if #significant_remaining_bufs == 1 then
              local last_buf_info = vim.fn.getbufinfo(significant_remaining_bufs[1])[1]
              if last_buf_info.name:match(".*NvimTree_%d*$") then
                vim.schedule(function ()
                  local all_wins = vim.api.nvim_list_wins()
                  local non_fidget_wins = vim.tbl_filter(function(win)
                    local buf = vim.api.nvim_win_get_buf(win)
                    return vim.bo[buf].filetype ~= "fidget"
                  end, all_wins)

                  if #non_fidget_wins == 1 then  -- Only one significant window left
                    vim.cmd "quit"  -- Quit Neovim entirely
                  elseif #non_fidget_wins > 1 then
                    vim.api.nvim_win_close(remaining_wins[1], true)  -- Close the NvimTree window safely
                  end
                end)
              end
            end
          end
        end
        -- local function tab_win_closed(winnr)
        --   local api = require"nvim-tree.api"
        --   local tabnr = vim.api.nvim_win_get_tabpage(winnr)
        --   local bufnr = vim.api.nvim_win_get_buf(winnr)
        --   local buf_info = vim.fn.getbufinfo(bufnr)[1]
        --   local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
        --   local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
        --   if buf_info.name:match(".*NvimTree_%d*$") then            -- closed buffer was nvim tree
        --     -- Close all nvim tree on :q
        --     if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
        --       api.tree.close()
        --     end
        --   else                                                      -- else closed buffer was normal buffer
        --     if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
        --       local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
        --       if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
        --         vim.schedule(function ()
        --           if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
        --             vim.cmd "quit"                                        -- then close all of vim
        --           else                                                  -- else there are more tabs open
        --             vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
        --           end
        --         end)
        --       end
        --     end
        --   end
        -- end

        vim.api.nvim_create_autocmd("WinClosed", {
          callback = function ()
            local winnr = tonumber(vim.fn.expand("<amatch>"))
            vim.schedule_wrap(tab_win_closed(winnr))
          end,
          nested = true
        })
      end,
    },
    {
      "stevearc/oil.nvim",
      opts = {
        columns = {},  -- Disable icons
        keymaps = {
          ["<C-s>"] = "actions.select_split",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-g>"] = "actions.select_tab",
        },
        view_options = {
          show_hidden = true,
        },
      },
    },
    {
      "nvim-lua/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzy-native.nvim",
      },
      keys = {
        { '<Leader>f', ':Telescope find_files find_command=fd,.,-H,--ignore-file,.gitignore,--exclude,.git,--type,f<CR>', silent = true },
        { '<Leader>b', ':Telescope buffers<CR>', silent = true },
        { 'gd', ':Telescope lsp_definitions<CR>',  silent = true },
        { 'gr', ':Telescope lsp_references<CR>',  silent = true },
        { 'gw', ':lua require("telescope.builtin").lsp_workspace_symbols{query = vim.fn.input("Query: ")}<CR>', silent = true },
        { 'gs', ':Telescope live_grep<CR>', silent = true },
      },
      config = function()
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local Path = require("plenary.path")

        local preview_scroll_up_one = function(prompt_bufnr)
          action_state.get_current_picker(prompt_bufnr).previewer:scroll_fn(-1)
        end
        local preview_scroll_down_one = function(prompt_bufnr)
          action_state.get_current_picker(prompt_bufnr).previewer:scroll_fn(1)
        end
        local create_buffer = function(prompt_bufnr)
          local prompt = action_state.get_current_line()
          local prompt_path = Path:new(prompt)
          actions.close(prompt_bufnr)
          vim.cmd.tabedit(prompt_path:absolute())
        end

        require("telescope").setup{
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
                ["<C-l>"] = create_buffer,
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
          },
        }

        require("telescope").load_extension("fzy_native")
      end
    },
    {
      "airblade/vim-rooter",
      init = function()
        vim.g.rooter_patterns = { '.git', 'Cargo.toml' }
      end
    },
    { "christoomey/vim-tmux-navigator" },
    {
      "ggandor/leap.nvim",
      config = function()
        vim.keymap.set("n", "s",  "<Plug>(leap-forward)", { silent = true })
        vim.keymap.set("n", "S",  "<Plug>(leap-backward)", { silent = true })
      end
    },
    {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = "nvim-tree/nvim-web-devicons",
      opts = {
        options = {
          mode = "tabs",
          show_buffer_close_icons = false,
          always_show_bufferline = false,
          auto_toggle_bufferline = true,
          show_buffer_icons = false,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
              local icon = level:match("error") and "" or ""
              return " " .. icon .. " " .. count
          end,
        },
      },
    },
    -- Language server protocol
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/luasnip",
        "rafamadriz/friendly-snippets"
      },
      config = function()
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

        require("luasnip.loaders.from_vscode").lazy_load()
      end
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "RRethy/vim-illuminate",
        "barreiroleo/ltex_extra.nvim",
      },
      config = function()
        -- Key bindings. Some LSP bindings are set when loading telescope.nvim.
        vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { silent = true })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { silent = true })
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { silent = true })
        vim.keymap.set('n', 'gD', vim.diagnostic.open_float, { silent = true })
        vim.keymap.set('n', 'gn', vim.diagnostic.goto_next, { silent = true })
        vim.keymap.set('n', 'gp', vim.diagnostic.goto_prev, { silent = true })
        vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, { silent = true })

        local lspconfig = require'lspconfig'
        local capabilities = require'cmp_nvim_lsp'.default_capabilities()

        if vim.fn.executable('clangd') == 1 then
          lspconfig.clangd.setup{
            on_attach = require'illuminate'.on_attach,
            capabilities = capabilities,
          }
          -- vim.cmd('autocmd FileType c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc')
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
          -- vim.cmd('autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc')
        end

        if vim.fn.executable('ltex-ls') == 1 then
          local ltex_on_attach = function(client, bufnr)
            require'illuminate'.on_attach(client, bufnr)
            require'ltex_extra'.setup{
              load_langs = { 'en-US' },
              path = vim.fn.expand("~") .. "/.local/share/ltex",
            }
          end
          lspconfig.ltex.setup{
            on_attach = ltex_on_attach,
            capabilities = capabilities,
            filetypes = { "bib", "gitcommit", "markdown", "plaintex", "rst", "tex", "text" },
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
        -- Remove when Neovim > 0.10.0 is released as
        -- https://github.com/neovim/neovim/pull/28904 was merged.
        -- vim.g.zig_fmt_parse_errors = 0
        -- vim.g.zig_fmt_autosave = 0

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

        -- XXX: Seems unnecessary. Try removing together with omnifunc.
        -- vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
        -- vim.opt.shortmess:append("c")
      end
    },
    {
      "simrat39/rust-tools.nvim",
      ft = "rust",
      dependencies = {
        'neovim/nvim-lspconfig',
      },
      config = function()
        -- rust-analyzer is set up by rust-tools.nvim.
        require'rust-tools'.setup {
          tools = {
            inlay_hints = {
              show_parameter_hints = true,
              other_hints_prefix = '  » ',
            }
          },
          server = {
            capabilities = require'cmp_nvim_lsp'.default_capabilities(),
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
        -- vim.cmd('autocmd FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc')
      end
    },
    {
      "j-hui/fidget.nvim",
      opts = {
        notification = { window = { winblend = 0 } },
      },
    },
    -- {
    --   'ray-x/lsp_signature.nvim',
    --   opts = {
    --     hint_prefix = "@",
    --   },
    -- },
    {
      "liuchengxu/vista.vim",
      init = function()
        vim.g.vista_default_executive = 'nvim_lsp'
        vim.g.vista_echo_cursor_strategy = 'floating_win'
        vim.g.vista_blink = { 0, 0 }
        vim.g.vista_top_level_blink = { 0, 0 }
        vim.g.vista_no_mappings = 1

        vim.keymap.set('n', '<Leader>t', ':Vista!!<CR>', { silent = true })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "vista", "vista_kind" },
          callback = function()
            vim.keymap.set(
              'n',
              '<CR>',
              [[:call vista#cursor#FoldOrJump()<CR>]],
              { silent = true, buffer = true }
            )
          end
        })
      end
    },
    -- Syntactic language support
    {
      "nvim-treesitter/nvim-treesitter",
      build = ':TSUpdate',
      config = function()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = { "c", "cpp", "python", "rust", "go", "vim", "vimdoc", "lua", "zig", "markdown" },
          highlight = {
            enable = true,
          },
        }
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = { "*.c", "*.h", "*.cpp", "*.hpp", "*.py", "*.rs", "*.go", "*.vim", "*.lua", "*.zig", "*.md" },
          callback = function()
            vim.treesitter.start()
          end,
        })
      end
    },
    {
      "lervag/vimtex",
      init = function()
        vim.g.vimtex_view_method = 'sioyek'
        vim.g.vimtex_view_sioyek_exe = '/Applications/sioyek.app/Contents/MacOS/sioyek'
        vim.g.vimtex_callback_progpath = 'arch -arm64 nvim'
        vim.g.vimtex_view_use_temp_files = 1
        vim.g.vimtex_quickfix_open_on_warning = 0
        vim.g.vimtex_quickfix_enabled = 0
        vim.g.vimtex_imaps_enabled = 0
        vim.g.vimtex_quickfix_autoclose_after_keystrokes = 4
        vim.g.vimtex_toc_enabled = 0
        vim.g.vimtex_view_reverse_search_edit_cmd = 'tabedit'
        vim.g.vimtex_quickfix_ignore_filters = {
          'warning',
          'Warning',
          'no output PDF',
          'underfull',
          'Underfull',
          'overfull',
          'Overfull',
        }
      end
    },
  },
  ui = { custom_keys = {}, },
  readme = { enabled = false },
})


------------------------------------------------------------------------------
-- Setup after lazy.nvim
------------------------------------------------------------------------------
-- LSP loading becomes lazy, so this has to be called manually.
vim.cmd.LspStart()
