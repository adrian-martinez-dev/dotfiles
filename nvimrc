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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rodrigore/coc-tailwind-intellisense', {'do': 'npm install'}
Plug 'vijaymarupudi/nvim-fzf'
Plug 'ibhagwan/fzf-lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'antoinemadec/coc-fzf'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'justinmk/vim-gtfo'
Plug 'wesQ3/vim-windowswap'
Plug 'mhinz/vim-startify'
Plug 'justinmk/vim-dirvish'
Plug 'ggandor/lightspeed.nvim'
Plug 'voldikss/vim-browser-search'
Plug 'mattn/emmet-vim'
Plug 'gcmt/taboo.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'pseewald/vim-anyfold'
Plug 'danilamihailov/beacon.nvim'
Plug 'romainl/vim-cool'
Plug 'sQVe/sort.nvim'
Plug 'kazhala/close-buffers.nvim'

" Colorschemes
Plug 'sainnhe/sonokai'
Plug 'sainnhe/edge'
Plug 'mcchrish/zenbones.nvim'
Plug 'rktjmp/lush.nvim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'

" Snippets & AutoComplete
Plug 'SirVer/ultisnips'
Plug 'mlaursen/vim-react-snippets'
Plug 'honza/vim-snippets'
Plug 'alvan/vim-closetag'

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'

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
set scrolloff=5
set signcolumn=yes
set list
set colorcolumn=120
set cmdheight=2
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

set clipboard=unnamedplus
if WINDOWS()
    set clipboard=unnamed
endif

set shiftwidth=2

" True color
set termguicolors

" Cursor line
" set cursorline

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

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
    autocmd BufWinEnter * call ResCur()
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
    autocmd FileType qf,help,fugitive setlocal signcolumn=no nonumber colorcolumn= nolist
    autocmd FilterWritePre * if &diff | setlocal foldcolumn=0 | endif
    autocmd TermOpen * setlocal foldcolumn=0 signcolumn=no nonumber winfixheight winfixwidth colorcolumn=
augroup END

" augroup StartifyFix
"   autocmd!
"   autocmd User StartifyReady let &l:stl = ' Startify'
" augroup END

function! CWD()
    let l:path = fnamemodify(getcwd(),":t")
    return l:path
endfunction

" Fillchars
set fillchars=vert:│,fold:-,diff:·,eob:\ 
" set fillchars+=foldopen:▾,foldsep:│,foldclose:▸
set fillchars+=foldopen:•,foldsep:│,foldclose:•


set statusline=%f%m

" Override color
augroup OverrideColor
    autocmd!
    autocmd ColorScheme * hi! link VertSplit LineNr
    autocmd ColorScheme * hi! link StatusLine LineNr
    autocmd ColorScheme * hi! link Beacon Cursor
    autocmd ColorScheme * hi! link ColorColumn CursorColumn
    " autocmd ColorScheme * hi! link FloatermBorder FloatBorder
augroup END

" Mappings
let g:mapleader = ','

" Backtick
inoremap '' `

command! -nargs=* T split | terminal <args>
command! -nargs=* VT vsplit | terminal <args>

" Search word under cursor and show results in quickfix without moving it
nnoremap <leader>- :execute "vimgrep /" . expand('<cword>') ."/j %"<CR>
" console.log
nnoremap <Leader>L "ayiw<CR>iconsole.log('<C-R>a: ', <C-R>a)<CR><Esc>

nnoremap <leader>M :top 11sp term://$SHELL<cr>
nnoremap <leader>m :below sp term://$SHELL<cr>
" nnoremap <leader>G :vertical Git<CR>

" Insert source bin/activate
tnoremap <leader>va source venv/bin/activate<cr>

" Jump to tag
nnoremap <leader>T <C-]>

nnoremap <leader>tn :tabnew<CR>

" Next/prev tab
nnoremap <silent> <tab> gt
nnoremap <silent> <s-tab> gT

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

" Autoclose
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"

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

" Set working directory to current file
command! FileDir cd %:p:h
command! TabDir tc %:p:h

" Plugins settings
" netrw
let g:netrw_altfile = 1
let g:netrw_banner = 0
let g:netrw_fastbrowse = 0

" UltiSnips
let g:UltiSnipsExpandTrigger='<c-e>'
let g:UltiSnipsListSnippets='<c-l>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
inoremap <c-x><c-k> <c-x><c-k>
let g:UltiSnipsSnippetDirectories = ['UltiSnips']

" Git
nmap <Leader>gc :T git checkout 
nmap <Leader>gP :T git push<cr>
" nmap <silent><Leader>gd :-1tabedit %<CR>:Gdiff<cr>
nmap <silent><Leader>gd :Gvdiffsplit<cr>
nmap <silent><Leader>gD :Ghdiffsplit<cr>
nmap <silent><Leader>gl :Glog<cr>
nmap <silent><Leader>gb :GBrowse<cr>

" Startify
nnoremap <leader>S :SSave!<cr>
nnoremap <leader>O :SLoad 

" let g:startify_disable_at_vimenter = 1
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

" coc-vim
let g:coc_global_extensions = [ 'coc-tsserver',
                              \ 'coc-eslint',
                              \ 'coc-prettier',
                              \ 'coc-react-refactor',
                              \ 'coc-css',
                              \ 'coc-json',
                              \ 'coc-jedi',
                              \ 'coc-highlight',
                              \ 'coc-emmet',
                              \ 'coc-ultisnips' ]

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Remap keys for gotos
nmap <silent> <leader>E <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>e <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" nmap <leader>D <Plug>(coc-codeaction)
xmap <leader>x <Plug>(coc-codeaction-selected)
nmap <leader>x <Plug>(coc-codeaction-selected)

command! -nargs=0 Prettier :CocCommand prettier.formatFile

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
let g:sonokai_style = 'default'
let g:sonokai_cursor = 'red'
let g:edge_cursor = 'red'
let g:zenbones_italic_comments = v:false
let g:zenbones_lightness = 'bright'
let g:zenbones_darkness = 'stark'

try
  colorscheme zenbones
catch
  " echo 'Colorscheme not found'
endtry

" fzf
nnoremap <Leader>a :FzfLua grep<cr>
nnoremap <Leader>W :FzfLua grep_cword<cr>
nnoremap <leader>A :FzfLua grep_visual<cr>
" tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
nnoremap <silent><leader>d :FzfLua commands<cr>
nnoremap <silent><leader>D :FzfLua builtin<cr>
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
augroup END

" Commands
command! -nargs=* Manage T docker-compose -f local.yml run --rm django python manage.py <args>
command! -nargs=* Test T docker-compose -f local.yml run --rm django pytest <args>
command! PullDotfiles T cd ~/dotfiles; git pull;
command! PushDotfiles T cd ~/dotfiles; git add .; git commit -m "Quick sync"; git push;

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

" taboo
let taboo_close_tabs_label = "X" 
let taboo_tab_format = " %r%m "
let taboo_renamed_tab_format = "  %l%m  "

" autoclose
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.htmldjango'
let g:closetag_filetypes = 'javascript'

" coc-fzf
let g:coc_fzf_preview = ''
let g:coc_fzf_opts = []

" anyfold
augroup AnyFold
  autocmd Filetype javascript AnyFoldActivate
  autocmd Filetype typescriptreact AnyFoldActivate
  autocmd Filetype typescript AnyFoldActivate
  autocmd Filetype python AnyFoldActivate
  autocmd Filetype vim AnyFoldActivate
  autocmd Filetype vue AnyFoldActivate
  autocmd Filetype html AnyFoldActivate
  autocmd Filetype css AnyFoldActivate
  autocmd Filetype scss AnyFoldActivate
augroup END

lua <<EOF
require('lualine').setup {
  sections = {
    lualine_a = {
      {'mode', fmt = function(str) return str:sub(1,1) end}
    },
    lualine_c = {
        {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
        }
      },
  },
  tabline = {
    lualine_a = {'tabs'},
    lualine_b = {'CWD'},
    lualine_y = {'buffers'},
  },
  inactive_sections = {
    lualine_a = {function() return [[•]] end},
    lualine_c = {
        {
        'filename',
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
        }
      },
  },
}
require('indent_blankline').setup {
  char = "▏",
  space_char_blankline = ' ',
  buftype_exclude = {'terminal'},
  filetype_exclude = {'help', "startify", 'fugitive', 'git'},
  show_current_context = true,
  show_current_context_start = false,
  show_first_indent_level = false,
  context_patterns = {
    'jsx_element',
    'jsx_self_closing_element',
    'object',
    'declaration',
    'expression',
    'pattern',
    'primary_expression',
    'statement',
    'switch_body',
  },
  -- char_highlight_list = {
  --     'Conditional',
  --     'LineNr',
  --     'Function',
  --     'Number',
  --     'Question',
  -- },
}
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
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
  }
}
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '┃', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '┃', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = false,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = true,
  keymaps = {
    ['n <leader>gn'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n <leader>gp'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},
    ['n <leader>gs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['v <leader>gs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>gu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>gR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <leader>ge'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>gB'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
    ['n <leader>gS'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
    ['n <leader>gU'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',
  },
}
require('fzf-lua').setup {
  winopts = {
    height           = 0.6,            -- window height
    width            = 0.8,            -- window width
    preview = {
      vertical       = 'down:60%',      -- up|down:size
      horizontal     = 'right:60%',     -- right|left:size
      layout         = 'flex',          -- horizontal|vertical|flex
      flip_columns   = 136,             -- #cols to switch to horizontal on flex
    },
    hl = {
      border         = 'FloatBorder',        -- border color (try 'FloatBorder')
    },
  },
  previewers = {
    builtin = {
      syntax         = false,         -- preview syntax highlight?
    },
  },
  fzf_colors = {
    ["fg"] = { "fg", "CursorLine" },
    ["bg"] = { "bg", "Normal" },
    ["hl"] = { "fg", "Comment" },
    ["fg+"] = { "fg", "Normal" },
    ["bg+"] = { "bg", "CursorLine" },
    ["hl+"] = { "fg", "Statement" },
    ["info"] = { "fg", "PreProc" },
    ["prompt"] = { "fg", "Conditional" },
    ["pointer"] = { "fg", "Exception" },
    ["marker"] = { "fg", "Keyword" },
    ["spinner"] = { "fg", "Label" },
    ["header"] = { "fg", "Comment" },
    ["gutter"] = { "bg", "Normal" },
  },
}
require('nvim-web-devicons').setup()
require('lightspeed').setup {
  safe_labels = {"s", "f", "n", "u", "t", "S", "F", "L", "N", "H", "G", "M", "U", "T", "Z"},
  labels = {"s", "f", "n", "j", "k", "l", "o", "i", "w", "e", "h", "g", "u", "t", "m", "v", "c", "a", "z",
     "S", "F", "L", "N", "H", "G", "M", "U", "T", "Z"}
}
EOF
