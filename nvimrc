" Identify plataform
silent function! OSX()
  return has('macunix')
endfunction
silent function! LINUX()
  return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
  return (has('win16') || has('win32') || has('win64'))
endfunction

" Plug setup directory
if LINUX()
    call plug#begin('~/.local/share/nvim/plugged')
endif

if OSX()
    call plug#begin('~/.local/share/nvim/plugged')
endif

if WINDOWS()
    call plug#begin('~\AppData\Local\nvim\plugged')
endif

" General
" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'mason-org/mason.nvim'
Plug 'mason-org/mason-lspconfig.nvim'

" Symbols
" Plug 'simrat39/symbols-outline.nvim'

" Autocompletion Engine
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lua'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

" Formatter
Plug 'sbdchd/neoformat'

" CodeGPT
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'main' }

Plug 'vijaymarupudi/nvim-fzf'
Plug 'ibhagwan/fzf-lua'
Plug 'nvim-lualine/lualine.nvim'
" Plug 'kyazdani42/nvim-web-devicons'
Plug 'tpope/vim-commentary'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'tpope/vim-eunuch'
Plug 'justinmk/vim-gtfo'
Plug 'wesQ3/vim-windowswap'
Plug 'mhinz/vim-startify'
Plug 'justinmk/vim-dirvish'
Plug 'voldikss/vim-browser-search'
Plug 'mattn/emmet-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'danilamihailov/beacon.nvim'
Plug 'romainl/vim-cool'
Plug 'sQVe/sort.nvim'
Plug 'kazhala/close-buffers.nvim'
Plug 'ggandor/leap.nvim'
Plug 'hiphish/rainbow-delimiters.nvim'

" Colorschemes
Plug 'mcchrish/zenbones.nvim'
Plug 'rktjmp/lush.nvim'
Plug 'RRethy/base16-nvim'
Plug 'lcroberts/persistent-colorscheme.nvim'


" Git
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'

" Snippets & AutoComplete
Plug 'alvan/vim-closetag'
Plug 'github/copilot.vim'

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-context'

call plug#end()

filetype plugin indent on
filetype plugin on
syntax enable

" General
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
endif
set wildmode=list:longest,full
set title
set novisualbell
set noequalalways
set hlsearch
set showmatch
set ignorecase
set smartcase
set inccommand=nosplit
set listchars=tab:▸\ ,eol:¬,extends:»,precedes:«,trail:•
set autoindent
set noshowmode
set noruler
set noshowcmd
set nofixendofline
set number
set mouse=a
set nospell
set foldlevel=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set scrolloff=5
set signcolumn=yes:1
set list
set showtabline=0
" set colorcolumn=120
" set cmdheight=2
" https://github.com/neovim/neovim/pull/17446
" feat(folds): add 'foldcolumndigits' option
" set foldcolumn=2

set expandtab
set splitright
set splitbelow
set sessionoptions-=folds
set sessionoptions+=tabpages,globals
set shortmess+=c
set updatetime=300
set laststatus=3

" https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
" Pasting from clipboard in WSL hangs with high cpu usage
set clipboard+=unnamedplus

set shiftwidth=2

" True color
set termguicolors

" Cursor line
" set cursorline

" Backup and undo
set noswapfile
set backup
if has('persistent_undo')
    set undofile
    set undolevels=10000
    set undoreload=10000
endif

function! InitializeDirectories()
    let l:parent = $HOME
    let l:prefix = 'nvim'
    let l:dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir', }

    if has('persistent_undo')
        let l:dir_list['undo'] = 'undodir'
    endif

    let l:common_dir = l:parent . '/.' . l:prefix

    for [l:dirname, l:settingname] in items(l:dir_list)
        let l:directory = l:common_dir . l:dirname . '/'
        if exists('*mkdir')
            if !isdirectory(l:directory)
                call mkdir(l:directory)
            endif
        endif
        if !isdirectory(l:directory)
            echo 'Warning: Unable to create backup directory: ' . l:directory
            echo 'Try: mkdir -p ' . l:directory
        else
            let l:directory = substitute(l:directory, ' ', '\\\\ ', 'g')
            exec 'set ' . l:settingname . '=' . l:directory
        endif
    endfor
endfunction
call InitializeDirectories()

" Autocmd rules
" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
function! ResCur()
    if line("'\"") <= line('$')
        silent! normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter, BufEnter * call ResCur()
augroup END

" Term start in insert mode
augroup TermCmd
    autocmd!
    autocmd TermOpen * startinsert
augroup END

" Quickfix below everything
augroup QfBl
    autocmd!
    autocmd FileType qf wincmd J
augroup END

" Move cursor to last position on file
" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
augroup FirstLineCommit
    autocmd!
    autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
augroup END

" Only show cursorline in the current window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter,InsertLeave * setlocal cursorline
    autocmd WinLeave,InsertEnter * setlocal nocursorline
augroup END

" Disable list on preview window
augroup DisableThingsFromWindows
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * if &previewwindow | setlocal nolist | setlocal colorcolumn= | endif
    autocmd FileType qf,help,fugitive setlocal foldcolumn=0 signcolumn=no nonumber colorcolumn= nolist
    autocmd FilterWritePre * if &diff | setlocal foldcolumn=0 | endif
    autocmd TermOpen * setlocal foldcolumn=0 signcolumn=no nonumber winfixheight winfixwidth colorcolumn=
    autocmd BufWinEnter * if &filetype == 'copilot-chat' | setlocal nonumber foldcolumn=0 | endif
augroup END

augroup PythonIndent
    autocmd!
    autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
augroup END

" Mix filetypes
" augroup FileTypes
"     autocmd!
"     autocmd BufNewFile,BufRead *.vue set filetype=html.vue
" augroup END

" augroup StartifyFix
"   autocmd!
"   autocmd User StartifyReady let &l:stl = ' Startify'
" augroup END

function! CWD()
    let l:path = fnamemodify(getcwd(),":t")
    return l:path
endfunction

" Fillchars
set fillchars=fold:-,diff:·,eob:\ 
set fillchars+=foldopen:•,foldclose:•

set statusline=%f%m

" Override color
augroup OverrideColor
    autocmd!
    autocmd ColorScheme * hi! link VertSplit LineNr
    autocmd ColorScheme * hi! link Beacon Cursor
    " autocmd ColorScheme * hi! link IndentBlankLineChar NonText
    " autocmd ColorScheme * hi! link TreesitterContext DiffAdd
    " autocmd ColorScheme * hi! Boolean gui=NONE cterm=NONE
    " autocmd ColorScheme * hi! Comment gui=NONE cterm=NONE
    " autocmd ColorScheme * hi! Constant gui=NONE cterm=NONE
    " autocmd ColorScheme * hi! Number gui=NONE cterm=NONE
    " autocmd ColorScheme * hi! SpecialKey gui=NONE cterm=NONE
    " autocmd ColorScheme * hi! TroubleSource gui=NONE cterm=NONE
    " autocmd ColorScheme * hi! WhichKeyValue gui=NONE cterm=NONE
    " autocmd ColorScheme * hi! diffNewFile gui=NONE cterm=NONE
    " autocmd ColorScheme * hi! diffOldFile gui=NONE cterm=NONE
augroup END

" Mappings
let g:mapleader = ','

" Backtick
" inoremap '' `

" Repeat last macro
" nnoremap , @@

command! -nargs=* T split | terminal <args>
command! -nargs=* VT vsplit | terminal <args>

" Search word under cursor and show results in quickfix without moving it
nnoremap <leader>- :execute "vimgrep /" . expand('<cword>') ."/j %"<CR>
" console.log
nnoremap <Leader>L "ayiw<CR>iconsole.log('<C-R>a: ', <C-R>a)<CR><Esc>

nnoremap <leader>M :top 15sp term://$SHELL<cr>
nnoremap <leader>m :below sp term://$SHELL<cr>
" nnoremap <leader>G :vertical Git<CR>

" Insert source bin/activate
tnoremap <leader>va source venv/bin/activate<cr>

" Jump to tag
nnoremap <leader>T <C-]>

" New tab
nnoremap <leader>tn :tabnew<CR>
" Set tab working directory
nnoremap <leader>td :tc %:p:h<CR>
" Zoom to tab
nnoremap <leader>to :tab sp<CR>

" Next/prev tab
nnoremap <silent> <tab> gt
nnoremap <silent> <s-tab> gT
nnoremap <silent> <s-right> :bnext<CR>
nnoremap <silent> <s-left> :bprevious<CR>

" Space to fold
nnoremap <space> za

" Quick edit vimrc
nnoremap <leader>cv :e ~/dotfiles/nvimrc<cr>
nnoremap <leader>sv :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>sg :source ~/.config/nvim/ginit.vim<cr>

if WINDOWS()
  nnoremap <leader>cv :e ~\AppData\Local\nvim\init.vim<cr>
  nnoremap <leader>sv :source ~\AppData\Local\nvim\init.vim<cr>
  nnoremap <leader>sg :source ~\AppData\Local\nvim\ginit.vim<cr>
endif

nnoremap <F1> <nop>
nnoremap Q <nop>
nnoremap q: <nop>

" Resizing windows
nnoremap <C-up> <C-W>-
nnoremap <C-down> <C-W>+
nnoremap <C-right> 5<C-W><
nnoremap <C-left> 5<C-W>>

" Substitute
nnoremap <leader>s :%s///gI<left><left><left><left>
vnoremap <leader>s :s///gI<left><left><left><left>

"Substitute all results from quickfix
nnoremap <leader>R :cfdo %s///g \| update<c-left><c-left><left><left><left><left>

" Select current line (no indentation)
nnoremap vv ^vg_

"Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

"Same for 0, home, end, etc
noremap $ g$
noremap <End> g<End>
noremap 0 g0
noremap <Home> g<Home>
noremap ^ g^

" Shortcuts
" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Adjust viewports to the same size
noremap <leader>we <C-w>=
noremap <leader><space> <c-w>_ \| <c-w>\|

" Easier horizontal scrolling
map zl zL
map zh zH

" Center cursor on search results
noremap n nzz
noremap N Nzz

"<leader>q to close buffer without closing the window
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" Toggle between invisible chars
nmap <leader>i :set list!<CR>

" Move between splits
" nnoremap <C-H> <C-W><C-H>
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>

" Term move between splits
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Copilot chat
nnoremap <leader>cc :CopilotChatToggle<CR>
vnoremap <leader>cc :CopilotChat<CR>

" Plugins settings
" netrw
let g:netrw_altfile = 1
let g:netrw_banner = 0
let g:netrw_fastbrowse = 0

" Git
nmap <Leader>gc :T git checkout 
nmap <Leader>gP :T git push<cr>
nmap <leader>gT :tab Git<CR>
nmap <leader>gv :vertical Git<CR>
" nmap <silent><Leader>gd :-1tabedit %<CR>:Gdiff<cr>
nmap <silent><Leader>gd :Gvdiffsplit<cr>
nmap <silent><Leader>gD :Ghdiffsplit<cr>
nmap <silent><Leader>gl :Glog<cr>
nmap <silent><Leader>gb :GBrowse<cr>

" Startify
nnoremap <leader>S :SSave!<cr>
nnoremap <leader>O :SLoad 

let g:startify_disable_at_vimenter = 1
let g:startify_custom_indices = ['f', 'd', 's']
let g:startify_session_number = 7
let g:startify_files_number = 7
let g:startify_session_sort = 1
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': [   '   Sessions']       },
      \ { 'type': 'files',     'header': [   '   MRU']            },
      \ ]

let g:startify_custom_header = [
            \ '                       █▀▀▄ █▀▀ █▀▀█ ▀█░█▀ ░▀░ █▀▄▀█',
            \ '                       █░░█ █▀▀ █░░█ ░█▄█░ ▀█▀ █░▀░█',
            \ '                       ▀░░▀ ▀▀▀ ▀▀▀▀ ░░▀░░ ▀▀▀ ▀░░░▀',
            \ ]

augroup StartifyAu
    autocmd!
    autocmd User Startified setlocal cursorline
    " https://github.com/neovim/neovim/issues/11330
    " autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"
augroup END

" Copilot
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-L> copilot#Accept()
imap <silent> <C-j> <Plug>(copilot-next)
imap <silent> <C-k> <Plug>(copilot-previous)

" diff
nnoremap <leader>ch :diffget //2<CR>
nnoremap <leader>cl :diffget //3<CR>

augroup init_quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup END

" Python syntax highlight
let g:python_highlight_all = 1

" Colorscheme
" 'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_disable_italic_comment = 1
let g:gruvbox_material_enable_italic = 0
let g:gruvbox_material_transparent_background = 0
let g:sonokai_style = 'default'
let g:sonokai_cursor = 'red'
let g:sonokai_disable_italic_comment = 1
let g:sonokai_enable_italic = 0
let g:sonokai_transparent_background = 1
let g:edge_cursor = 'red'
let g:edge_disable_italic_comment = 1
let g:edge_transparent_background = 1
let g:zenbones_italic_comments = v:false
let g:neobones_italic_comments = v:false
let g:zenbones_lightness = 'bright'
let g:zenbones_darkness = 'stark'
let g:zenbones_transparent_background = v:true
let g:neobones_transparent_background = v:true
" if $HOSTNAME == 'ADRIAN-PC'
"   set background=dark
" else
"   set background=light
" endif
set background=dark

try
  colorscheme base16-default-dark
catch
  " echo 'Colorscheme not found'
endtry

" fzf-lua
nnoremap <Leader>a :FzfLua grep_project<cr>
nnoremap <Leader>W :FzfLua grep_cword<cr>
nnoremap <leader>A :FzfLua resume<cr>
nnoremap <silent><leader>D :FzfLua commands<cr>
nnoremap <silent><leader>d :FzfLua builtin<cr>
nnoremap <silent><leader>r :FzfLua registers<cr>
nnoremap <silent><leader>v :FzfLua buffers<cr>
nnoremap <silent><leader>l :FzfLua blines file_icons=false<cr>
nnoremap <silent><leader>F :FzfLua files<cr>
nnoremap <silent><leader>f :FzfLua git_files<cr>
nnoremap <silent><leader>G :FzfLua git_status<cr>

augroup fzfpopupter
  autocmd!
  autocmd FileType fzf exe 'tnoremap <buffer><nowait> <C-j> <Down>'
        \ | tnoremap <buffer><nowait> <C-k> <Up>
  autocmd FileType fzf tnoremap <buffer> <esc> <c-c>
augroup END

" Commands
command! -nargs=* Manage T docker compose -f local.yml run --rm django python manage.py <args>
command! -nargs=* Test T docker compose -f local.yml run --rm django pytest <args>
command! PullDotfiles T cd ~/dotfiles; git pull;
command! PushDotfiles T cd ~/dotfiles; git add .; git commit -m "Quick sync"; git push;
command! TrailingWhitespaceRemove :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
command! CarriageReturnRemove :%s/\r//g
" Fix commit to the wrong branch
command! GitResetSoft T git reset --soft HEAD^

" Web search
nmap <silent> <Leader>kj <Plug>SearchNormal
vmap <silent> <Leader>kj <Plug>SearchVisual
nnoremap <leader>j :BrowserSearch 

" dirvish
augroup dirvish_config
    autocmd!
    autocmd FileType dirvish nnoremap <buffer> + :edit %
    autocmd FileType dirvish nmap <buffer> q <Plug>(dirvish_quit)
    autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
augroup END

let g:dirvish_mode = ':sort ,^.*[\/],'

" emmet
" c-y to expand
let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\}

" autoclose
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.htmldjango'
let g:closetag_filetypes = 'javascript'

" hop
" nnoremap s :HopWord<CR>
let g:rainbow_delimiters = {
    \ 'blacklist': ['markdown', 'comment'],
\ }

lua <<EOF
vim.lsp.enable({
  'pyright',
  'ts_ls',
})
-- Background sync
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then return end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function() io.write("\027]111\027\\") end,
})
require("mason").setup()
-- require('symbols-outline').setup()
require('treesitter-context').setup()
require('lualine').setup {
  options = {
    globalstatus = true,
    icons_enabled = false,
  },
  sections = {
    lualine_a = {
      {'mode', fmt = function(str) return str:sub(1,1) end}
    },
    lualine_c = { 'filename' },
    lualine_x = { "encoding", "fileformat", "filetype" },
  },
  -- tabline = {
  --   lualine_a = {'tabs'},
  --   lualine_b = {'CWD'},
  --   lualine_y = {'buffers'},
  -- },
  inactive_sections = {
    lualine_a = {function() return [[•]] end},
    lualine_c = {
      {
        'filename',
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
      }
    },
  },
  winbar = {
    lualine_a = {'tabs'},
    lualine_b = {'CWD'},
    lualine_c = {},
    lualine_z = {
      {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
      }
    },
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_z = {
      {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
      }
    },
  },
}
require('ibl').setup {}
-- require('rainbow-delimiters').setup {}
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = { "markdown", "sh", "bash" },
    -- disable = { "sh", "bash" },
  },
  indent = {
    enable = true
  },
  ensure_installed = {
    "typescript",
    "javascript",
    "python",
    "tsx",
    "json",
    "html",
    "scss",
    "vim",
    "vue",
    "diff",
    -- "markdown",
    -- "markdown_inline",
  },
}
require('gitsigns').setup {
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false,

  -- Keymaps
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', '<leader>gn', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '<leader>gp', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>gs', gs.stage_hunk)
    map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>gu', gs.undo_stage_hunk)
    map('n', '<leader>gr', gs.reset_hunk)
    map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>gR', gs.reset_buffer)
    map('n', '<leader>ge', gs.preview_hunk)
    map('n', '<leader>gB', function() gs.blame_line{full=true} end)
    map('n', '<leader>gS', gs.stage_buffer)
    -- map('n', '<leader>tb', gs.toggle_current_line_blame)
    -- map('n', '<leader>hd', gs.diffthis)
    -- map('n', '<leader>hD', function() gs.diffthis('~') end)
    -- map('n', '<leader>td', gs.toggle_deleted)
  end
}
require('fzf-lua').setup {
  defaults = {
    file_icons = false,
    git_icons = false,
  },
  winopts = {
    height           = 0.6,            -- window height
    width            = 0.8,            -- window width
    preview = {
      vertical       = 'down:60%',      -- up|down:size
      horizontal     = 'right:60%',     -- right|left:size
      layout         = 'flex',          -- horizontal|vertical|flex
      flip_columns   = 160,             -- #cols to switch to horizontal on flex
    },
  },
  previewers = {
    builtin = {
      syntax         = false,         -- preview syntax highlight?
    },
  },
  git = {
    files = {
      cmd           = 'git ls-files --exclude-standard --cached --others',
    },
  },
  fzf_colors = {
      ["fg"]          = { "fg", "CursorLine" },
      ["bg"]          = { "bg", "Normal" },
      ["hl"]          = { "fg", "Comment" },
      ["fg+"]         = { "fg", "Normal" },
      ["bg+"]         = { "bg", "CursorLine" },
      ["hl+"]         = { "fg", "Statement" },
      ["info"]        = { "fg", "PreProc" },
      ["prompt"]      = { "fg", "Conditional" },
      ["pointer"]     = { "fg", "Exception" },
      ["marker"]      = { "fg", "Keyword" },
      ["spinner"]     = { "fg", "Label" },
      ["header"]      = { "fg", "Comment" },
      ["gutter"]      = { "bg", "Normal" },
  },
}
-- require('nvim-web-devicons').setup()
-- require'hop'.setup()
-- require("statuscol").setup {
--  foldfunc = "builtin",
--  setopt = true,
--  separator = "   ",
--  -- order = "SNsF",        -- "FSNs order of the fold, sign, line number and separator segments
--}
require('leap').add_default_mappings()
vim.keymap.del({'x', 'o'}, 'x')

vim.diagnostic.config({
  virtual_text = true,
})
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local map = function(mode, lhs, rhs)
      local opts = {remap = false, buffer = bufnr}
      vim.keymap.set(mode, lhs, rhs, opts)
    end
    -- LSP actions
    map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    -- map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
    map('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    map('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

    -- Diagnostics
    map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    map('n', '<leader>E', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    map('n', '<leader>e', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end,
})
require("persistent-colorscheme").setup()
require("CopilotChat").setup {
  model = 'claude-3.7-sonnet', -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
  agent = 'copilot', -- Default agent to use, see ':CopilotChatAgents' for available agents (can be specified manually in prompt via @).
  -- default window options
  -- context = 'buffer',
  window = {
    layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
    -- width = 0.8, -- fractional width of parent, or absolute width in columns when > 1
    width = 0.4, -- fractional width of parent, or absolute width in columns when > 1
    height = 0.6, -- fractional height of parent, or absolute height in rows when > 1
    -- Options below only apply to floating windows
    relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
    border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
    row = nil, -- row position of the window, default is centered
    col = nil, -- column position of the window, default is centered
    title = 'Copilot Chat', -- title of chat window
    footer = nil, -- footer of chat window
    zindex = 1, -- determines if window is on top or below other floating windows
  },

  show_help = true, -- Shows help message as virtual lines when waiting for user input
  show_folds = true, -- Shows folds for sections in chat
  highlight_selection = true, -- Highlight selection
  highlight_headers = true, -- Highlight headers in chat, disable if using markdown renderers (like render-markdown.nvim)
  auto_follow_cursor = true, -- Auto-follow cursor in chat
  auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
  insert_at_end = false, -- Move cursor to end of buffer when inserting text
  clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
  -- Static config starts here (can be configured only via setup function)

  debug = false, -- Enable debug logging (same as 'log_level = 'debug')
  log_level = 'info', -- Log level to use, 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
  proxy = nil, -- [protocol://]host[:port] Use this proxy
  allow_insecure = false, -- Allow insecure server connections
  chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)

  -- default mappings
  mappings = {
    complete = {
      insert = '<Tab>',
    },
    close = {
      normal = '<Esc>',
      insert = '<C-c>',
    },
    reset = {
      normal = '',
      insert = '',
    },
    submit_prompt = {
      normal = '<CR>',
      insert = '<C-s>',
    },
    toggle_sticky = {
      detail = 'Makes line under cursor sticky or deletes sticky line.',
      normal = 'gr',
    },
    accept_diff = {
      normal = '<C-y>',
      insert = '<C-y>',
    },
    jump_to_diff = {
      normal = 'gj',
    },
    quickfix_diffs = {
      normal = 'gq',
    },
    yank_diff = {
      normal = 'gy',
      register = '"',
    },
    show_diff = {
      normal = 'gd',
    },
    show_info = {
      normal = 'gi',
    },
    show_context = {
      normal = 'gc',
    },
    show_help = {
      normal = 'gh',
    },
  },
}
vim.cmd([[cab cc CopilotChat]])
EOF
