-- ============================================================================
-- Leader
-- ============================================================================

vim.g.mapleader = ','

-- ============================================================================
-- Platform
-- ============================================================================

local is_windows = vim.fn.has('win32') == 1
local cfg_dir = is_windows and '~/AppData/Local/nvim' or '~/.config/nvim'

-- ============================================================================
-- lazy.nvim Bootstrap
-- ============================================================================

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Helpers
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function cwd_component()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
end

local function ensure_dirs()
  local base = vim.fn.expand('~/.nvim')
  local dirs = {
    backup = 'backupdir',
    views = 'viewdir',
    undo = 'undodir',
  }

  for dirname, optname in pairs(dirs) do
    local dir = base .. dirname .. '/'
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
    if vim.fn.isdirectory(dir) == 1 then
      vim.opt[optname] = dir
    else
      vim.notify('Warning: Unable to create backup directory: ' .. dir, vim.log.levels.WARN)
    end
  end
end

-- ============================================================================
-- Options
-- ============================================================================

if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep --no-heading'
end

vim.opt.wildmode = { 'list:longest', 'full' }
vim.opt.title = true
vim.opt.visualbell = false
vim.opt.equalalways = false
vim.opt.hlsearch = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'nosplit'
vim.opt.listchars = { tab = '▸ ', eol = '¬', extends = '»', precedes = '«', trail = '•' }
vim.opt.autoindent = true
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.fixendofline = false
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.spell = false
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'
vim.opt.scrolloff = 5
vim.opt.signcolumn = 'yes:1'
vim.opt.list = true
vim.opt.showtabline = 0
vim.opt.expandtab = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.sessionoptions:remove('folds')
vim.opt.sessionoptions:append('globals')
vim.opt.shortmess:append('c')
vim.opt.updatetime = 300
vim.opt.laststatus = 3
vim.opt.clipboard:append('unnamedplus')
vim.opt.shiftwidth = 2
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.backup = true
vim.opt.fillchars = { fold = '-', diff = '·', eob = ' ', foldopen = '•', foldclose = '•' }
vim.opt.background = 'dark'
vim.opt.statusline = '%f%m'

vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.undoreload = 10000

autocmd('UIEnter', {
  group = augroup('EnsureDirs', { clear = true }),
  callback = function() vim.schedule(ensure_dirs) end,
})

-- ============================================================================
-- Autocommands
-- ============================================================================

autocmd('BufReadPost', {
  group = augroup('resCur', { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd('FileType', {
  group = augroup('QfBl', { clear = true }),
  pattern = 'qf',
  command = 'wincmd J',
})

autocmd('BufReadPost', {
  group = augroup('FirstLineCommit', { clear = true }),
  pattern = { 'COMMIT_EDITMSG', 'MERGE_MSG' },
  callback = function()
    vim.fn.setpos('.', { 0, 1, 1, 0 })
  end,
})

local cursorline_au = augroup('CursorLineOnlyInActiveWindow', { clear = true })
autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter', 'InsertLeave' }, {
  group = cursorline_au,
  callback = function() vim.opt_local.cursorline = true end,
})
autocmd({ 'WinLeave', 'InsertEnter' }, {
  group = cursorline_au,
  callback = function() vim.opt_local.cursorline = false end,
})

local disable_au = augroup('DisableThingsFromWindows', { clear = true })
autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
  group = disable_au,
  callback = function()
    if vim.wo.previewwindow then
      vim.opt_local.list = false
      vim.opt_local.colorcolumn = ''
    end
  end,
})
autocmd('FileType', {
  group = disable_au,
  pattern = { 'qf', 'help', 'fugitive' },
  callback = function()
    vim.opt_local.foldcolumn = '0'
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.number = false
    vim.opt_local.colorcolumn = ''
    vim.opt_local.list = false
  end,
})
autocmd('FilterWritePre', {
  group = disable_au,
  callback = function()
    if vim.wo.diff then vim.opt_local.foldcolumn = '0' end
  end,
})
autocmd('TermOpen', {
  group = disable_au,
  callback = function()
    vim.opt_local.foldcolumn = '0'
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.number = false
    vim.opt_local.winfixheight = true
    vim.opt_local.winfixwidth = true
    vim.opt_local.colorcolumn = ''
  end,
})

autocmd('FileType', {
  group = augroup('PythonIndent', { clear = true }),
  pattern = 'python',
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

autocmd('ColorScheme', {
  group = augroup('OverrideColor', { clear = true }),
  callback = function()
    vim.cmd('hi! link VertSplit LineNr')
  end,
})

autocmd({ 'UIEnter', 'ColorScheme' }, {
  group = augroup('TerminalBackgroundSync', { clear = true }),
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
    if not normal.bg then
      return
    end
    io.write(string.format('\027]11;#%06x\027\\', normal.bg))
  end,
})

autocmd('UILeave', {
  group = augroup('TerminalBackgroundReset', { clear = true }),
  callback = function()
    io.write('\027]111\027\\')
  end,
})

autocmd('QuickFixCmdPost', {
  group = augroup('init_quickfix', { clear = true }),
  pattern = '[^l]*',
  command = 'cwindow',
})

autocmd('QuickFixCmdPost', {
  group = augroup('init_quickfix_l', { clear = true }),
  pattern = 'l*',
  command = 'lwindow',
})

autocmd('BufWritePre', {
  group = augroup('AutoMkdir', { clear = true }),
  pattern = '*',
  callback = function(args)
    vim.fn.mkdir(vim.fn.fnamemodify(args.file, ':p:h'), 'p')
  end,
})

-- ============================================================================
-- Keymap Helpers
-- ============================================================================

local map = vim.keymap.set
local opts = { noremap = true }
local silent = { noremap = true, silent = true }

-- ============================================================================
-- Commands
-- ============================================================================

vim.api.nvim_create_user_command('T', function(command)
  vim.cmd('split | terminal ' .. command.args)
end, { nargs = '*' })

vim.api.nvim_create_user_command('VT', function(command)
  vim.cmd('vsplit | terminal ' .. command.args)
end, { nargs = '*' })

vim.api.nvim_create_user_command('Manage', function(command)
  vim.cmd('T docker compose -f local.yml run --rm django python manage.py ' .. command.args)
end, { nargs = '*' })

vim.api.nvim_create_user_command('Test', function(command)
  vim.cmd('T docker compose -f local.yml run --rm django pytest ' .. command.args)
end, { nargs = '*' })

vim.api.nvim_create_user_command('PullDotfiles', 'T cd ~/dotfiles; git pull;', {})
vim.api.nvim_create_user_command('PushDotfiles', 'T cd ~/dotfiles; git add .; git commit -m "Quick sync"; git push;', {})
vim.api.nvim_create_user_command('GitResetSoft', 'T git reset --soft HEAD^', {})
vim.api.nvim_create_user_command('TrailingWhitespaceRemove', function()
  local search = vim.fn.getreg('/')
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setreg('/', search)
  vim.cmd('nohlsearch')
end, {})
vim.api.nvim_create_user_command('CarriageReturnRemove', [[%s/\r//g]], {})

-- ============================================================================
-- Keymaps
-- ============================================================================

map('n', '<leader>-', [[<cmd>execute "vimgrep /" . expand('<cword>') ."/j %"<CR>]], opts)
map('n', '<Leader>L', [["ayiw<CR>iconsole.log('<C-R>a: ', <C-R>a)<CR><Esc>]], opts)
map('n', '<leader>M', '<cmd>top sp term://$SHELL<CR>', opts)
map('n', '<leader>m', '<cmd>below sp term://$SHELL<CR>', opts)
map('t', '<leader>va', 'source venv/bin/activate<CR>', opts)
map('n', '<leader>T', '<C-]>', opts)
map('n', '<leader>tn', '<cmd>tabnew<CR>', opts)
map('n', '<leader>td', '<cmd>tc %:p:h<CR>', opts)
map('n', '<leader>to', '<cmd>tab sp<CR>', opts)
map('n', '<Tab>', 'gt', silent)
map('n', '<S-Tab>', 'gT', silent)
map('n', '<S-Right>', '<cmd>bnext<CR>', silent)
map('n', '<S-Left>', '<cmd>bprevious<CR>', silent)
map('n', '<Space>', 'za', opts)
map('n', '<leader>cv', '<cmd>e ' .. (is_windows and '~/AppData/Local/nvim/init.lua' or '~/dotfiles/init.lua') .. '<CR>', opts)
map('n', '<leader>sv', '<cmd>source ' .. cfg_dir .. '/init.lua<CR>', opts)
map('n', '<leader>sg', '<cmd>source ' .. cfg_dir .. '/ginit.vim<CR>', opts)

map('n', '<F1>', '<Nop>', opts)
map('n', 'Q', '<Nop>', opts)
map('n', 'q:', '<Nop>', opts)
map('n', '<C-Up>', '<C-W>-', opts)
map('n', '<C-Down>', '<C-W>+', opts)
map('n', '<C-Right>', '5<C-W><', opts)
map('n', '<C-Left>', '5<C-W>>', opts)
map('n', '<leader>s', ':%s///gI<Left><Left><Left><Left>', opts)
map('v', '<leader>s', ':s///gI<Left><Left><Left><Left>', opts)
map('n', '<leader>R', ':%s///g | update<C-Left><C-Left><Left><Left><Left><Left>', opts)
map('n', 'vv', '^vg_', opts)
map({ 'n', 'v' }, 'j', 'gj', opts)
map({ 'n', 'v' }, 'k', 'gk', opts)
map({ 'n', 'v' }, '$', 'g$', opts)
map({ 'n', 'v' }, '<End>', 'g<End>', opts)
map({ 'n', 'v' }, '0', 'g0', opts)
map({ 'n', 'v' }, '<Home>', 'g<Home>', opts)
map({ 'n', 'v' }, '^', 'g^', opts)
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)
map('n', '<leader>we', '<C-w>=', opts)
map('n', '<leader><Space>', '<C-w>_ | <C-w>|', opts)
map({ 'n', 'v' }, 'zl', 'zL', opts)
map({ 'n', 'v' }, 'zh', 'zH', opts)
map({ 'n', 'v' }, 'n', 'nzz', opts)
map({ 'n', 'v' }, 'N', 'Nzz', opts)
map('n', '<leader>q', '<cmd>bp<bar>sp<bar>bn<bar>bd<CR>', opts)
map('n', '<leader>i', '<cmd>set list!<CR>', opts)
map('t', '<C-h>', '<C-\\><C-n><C-w>h', opts)
map('t', '<C-j>', '<C-\\><C-n><C-w>j', opts)
map('t', '<C-k>', '<C-\\><C-n><C-w>k', opts)
map('t', '<C-l>', '<C-\\><C-n><C-w>l', opts)

-- ============================================================================
-- Plugin Globals
-- ============================================================================

vim.g.netrw_altfile = 1
vim.g.netrw_banner = 0
vim.g.netrw_fastbrowse = 0
vim.g.dirvish_mode = [[:sort ,^.*[\/],]]

map('n', '<Leader>gc', ':T git checkout ', opts)
map('n', '<Leader>gP', '<cmd>T git push<CR>', opts)
map('n', '<leader>gT', '<cmd>tab Git<CR>', opts)
map('n', '<leader>gv', '<cmd>vertical Git<CR>', opts)
map('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>', silent)
map('n', '<leader>gD', '<cmd>Ghdiffsplit<CR>', silent)
map('n', '<leader>gl', '<cmd>Glog<CR>', silent)
map('n', '<leader>gb', '<cmd>GBrowse<CR>', silent)
map('n', '<leader>ch', '<cmd>diffget //2<CR>', opts)
map('n', '<leader>cl', '<cmd>diffget //3<CR>', opts)

map('n', '<leader>S', '<cmd>SSave!<CR>', opts)
map('n', '<leader>O', ':SLoad ', opts)

-- ============================================================================
-- Plugins
-- ============================================================================

require('lazy').setup({
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', opts = {} },
  { 'RRethy/base16-nvim', lazy = false, priority = 1000 },
  { 'lcroberts/persistent-colorscheme.nvim', lazy = true, event = 'ColorScheme', opts = {} },

  {
    'nvim-lualine/lualine.nvim',
    event = 'UIEnter',
    opts = function()
      local filename_path1 = { 'filename', file_status = true, path = 1 }
      return {
        options = {
          globalstatus = true,
          icons_enabled = false,
        },
        sections = {
          lualine_a = {
            { 'mode', fmt = function(str) return str:sub(1, 1) end },
          },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
        },
        inactive_sections = {
          lualine_a = { function() return '•' end },
          lualine_c = { filename_path1 },
        },
        winbar = {
          lualine_a = { 'tabs' },
          lualine_b = { cwd_component },
          lualine_c = {},
          lualine_z = { filename_path1 },
        },
        inactive_winbar = {
          lualine_a = { 'tabs' },
          lualine_b = { cwd_component },
          lualine_c = {},
          lualine_z = { filename_path1 },
        },
      }
    end,
  },

  {
    'vijaymarupudi/nvim-fzf',
    lazy = true,
  },
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'vijaymarupudi/nvim-fzf' },
    keys = {
      { '<Leader>a', '<cmd>FzfLua grep_project<CR>', desc = 'Grep project' },
      { '<Leader>W', '<cmd>FzfLua grep_cword<CR>', desc = 'Grep word under cursor' },
      { '<leader>A', '<cmd>FzfLua resume<CR>', desc = 'Resume last fzf' },
      { '<leader>D', '<cmd>FzfLua commands<CR>', desc = 'Commands' },
      { '<leader>d', '<cmd>FzfLua builtin<CR>', desc = 'Fzf builtin' },
      { '<leader>r', '<cmd>FzfLua registers<CR>', desc = 'Registers' },
      { '<leader>v', '<cmd>FzfLua buffers<CR>', desc = 'Buffers' },
      { '<leader>l', '<cmd>FzfLua blines file_icons=false<CR>', desc = 'Buffer lines' },
      { '<leader>F', '<cmd>FzfLua files<CR>', desc = 'Files' },
      { '<leader>f', '<cmd>FzfLua git_files<CR>', desc = 'Git files' },
      { '<leader>G', '<cmd>FzfLua git_status<CR>', desc = 'Git status' },
    },
    opts = {
      defaults = {
        file_icons = false,
        git_icons = false,
      },
      winopts = {
        height = 0.6,
        width = 0.8,
        preview = {
          vertical = 'down:60%',
          horizontal = 'right:60%',
          layout = 'flex',
          flip_columns = 160,
        },
      },
      previewers = {
        builtin = {
          syntax = false,
        },
      },
      git = {
        files = {
          cmd = 'git ls-files --exclude-standard --cached --others',
        },
      },
      fzf_colors = {
        fg = { 'fg', 'CursorLine' },
        bg = { 'bg', 'Normal' },
        hl = { 'fg', 'Comment' },
        ['fg+'] = { 'fg', 'Normal' },
        ['bg+'] = { 'bg', 'CursorLine' },
        ['hl+'] = { 'fg', 'Statement' },
        info = { 'fg', 'PreProc' },
        prompt = { 'fg', 'Conditional' },
        pointer = { 'fg', 'Exception' },
        marker = { 'fg', 'Keyword' },
        spinner = { 'fg', 'Label' },
        header = { 'fg', 'Comment' },
        gutter = { 'bg', 'Normal' },
      },
    },
    config = function(_, opts)
      require('fzf-lua').setup(opts)
      autocmd('FileType', {
        group = augroup('fzfpopupter', { clear = true }),
        pattern = 'fzf',
        callback = function()
          map('t', '<C-j>', '<Down>', { buffer = true, nowait = true })
          map('t', '<C-k>', '<Up>', { buffer = true, nowait = true })
          map('t', '<Esc>', '<C-c>', { buffer = true })
        end,
      })
    end,
  },

  { 'tpope/vim-commentary' },
  { 'tpope/vim-eunuch', cmd = { 'Delete', 'Unlink', 'Move', 'Rename', 'Copy', 'Duplicate', 'Chmod', 'Mkdir', 'Cfind', 'Clocate', 'SudoWrite', 'SudoEdit', 'Wall', 'Touch', 'Remove' } },
  { 'justinmk/vim-gtfo' },
  { 'wesQ3/vim-windowswap' },
  { 'christoomey/vim-tmux-navigator' },
  { 'romainl/vim-cool' },
  { 'sbdchd/neoformat', cmd = 'Neoformat' },

  {
    'voldikss/vim-browser-search',
    keys = {
      { '<Leader>kj', '<Plug>SearchNormal', mode = 'n', silent = true, remap = true },
      { '<Leader>kj', '<Plug>SearchVisual', mode = 'v', silent = true, remap = true },
      { '<leader>j', ':BrowserSearch ', mode = 'n' },
    },
  },

  {
    'mhinz/vim-startify',
    init = function()
      vim.g.startify_disable_at_vimenter = 1
      vim.g.startify_custom_indices = { 'f', 'd', 's' }
      vim.g.startify_session_number = 7
      vim.g.startify_files_number = 7
      vim.g.startify_session_sort = 1
      vim.g.startify_lists = {
        { type = 'sessions', header = { '   Sessions' } },
        { type = 'files', header = { '   MRU' } },
      }
      vim.g.startify_custom_header = {
        '                       █▀▀▄ █▀▀ █▀▀█ ▀█░█▀ ░▀░ █▀▄▀█',
        '                       █░░█ █▀▀ █░░█ ░█▄█░ ▀█▀ █░▀░█',
        '                       ▀░░▀ ▀▀▀ ▀▀▀▀ ░░▀░░ ▀▀▀ ▀░░░▀',
      }
      autocmd('User', {
        group = augroup('StartifyAu', { clear = true }),
        pattern = 'Startified',
        command = 'setlocal cursorline',
      })
    end,
  },

  {
    'justinmk/vim-dirvish',
    config = function()
      autocmd('FileType', {
        group = augroup('dirvish_config', { clear = true }),
        pattern = 'dirvish',
        callback = function()
          map('n', '+', ':edit %', { buffer = true })
          map('n', 'q', '<Plug>(dirvish_quit)', { buffer = true, remap = true })
        end,
      })
    end,
  },

  { 'tpope/vim-fugitive' },
  { 'rbong/vim-flog', dependencies = { 'tpope/vim-fugitive' } },
  { 'tpope/vim-rhubarb', dependencies = { 'tpope/vim-fugitive' } },
  { 'shumphrey/fugitive-gitlab.vim', dependencies = { 'tpope/vim-fugitive' } },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signcolumn = true,
      numhl = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function bmap(mode, lhs, rhs, bopts)
          bopts = bopts or {}
          bopts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, bopts)
        end

        bmap('n', '<leader>gn', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        bmap('n', '<leader>gp', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        bmap('n', '<leader>gs', gs.stage_hunk)
        bmap('v', '<leader>gs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
        bmap('n', '<leader>gu', gs.undo_stage_hunk)
        bmap('n', '<leader>gr', gs.reset_hunk)
        bmap('v', '<leader>gr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
        bmap('n', '<leader>gR', gs.reset_buffer)
        bmap('n', '<leader>ge', gs.preview_hunk)
        bmap('n', '<leader>gB', function() gs.blame_line({ full = true }) end)
        bmap('n', '<leader>gS', gs.stage_buffer)
      end,
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    build = ':TSInstall! lua python javascript typescript tsx',
  },

  {
    'sychen52/smart-term-esc.nvim',
    opts = {
      key = '<Esc>',
      except = { 'nvim', 'fzf', 'opencode', 'codex', 'claude' },
    },
  },
}, {
  lockfile = vim.fn.expand('~/dotfiles/lazy-lock.json'),
})

-- ============================================================================
-- Colorscheme
-- ============================================================================

pcall(vim.cmd.colorscheme, 'base16-tokyo-night-terminal-dark')
