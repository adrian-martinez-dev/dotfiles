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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'antoinemadec/coc-fzf'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'justinmk/vim-gtfo'
Plug 'wesQ3/vim-windowswap'
Plug 'mhinz/vim-startify'
Plug 'justinmk/vim-dirvish'
Plug 'phaazon/hop.nvim'
Plug 'voldikss/vim-browser-search'
Plug 'rhysd/git-messenger.vim'
Plug 'mattn/emmet-vim'
Plug 'gcmt/taboo.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'pseewald/vim-anyfold'
Plug 'danilamihailov/beacon.nvim'
Plug 'romainl/vim-cool'

" Colorschemes
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/sonokai'
Plug 'sainnhe/edge'

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
Plug 'jiangmiao/auto-pairs'
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
set inccommand=split
set listchars=tab:▸\ ,eol:¬,extends:»,precedes:«,trail:•
set autoindent
set noshowcmd
set nofixendofline
set number
" set foldcolumn="auto:3"
set mouse=a

set nospell
set hidden
set foldlevel=99
set scrolloff=5
set signcolumn=yes
set list
set colorcolumn=120
" let &colorcolumn = join(range(121,999), ',')

set expandtab
set splitright
set splitbelow
set sessionoptions-=folds
set sessionoptions+=tabpages,globals
set shortmess+=c

set clipboard=unnamedplus
if WINDOWS()
    set clipboard=unnamed
endif

set shiftwidth=2

" True color
set termguicolors

" Cursor line
" set cursorline

:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
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
" augroup QfBl
"     autocmd!
"     autocmd FileType qf wincmd J
" augroup END

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
    autocmd TermOpen * setlocal foldcolumn=0 signcolumn=no nonumber winfixheight winfixwidth
augroup END

" Fillchars
set fillchars=vert:│,fold:-,diff:·,stlnc:─,eob:\ 
set fillchars+=foldopen:▾,foldsep:│,foldclose:▸

function! CWD()
    let l:path = fnamemodify(getcwd(),":t")
    return l:path
endfunction

function! ActiveStatus()
    let statusline=""
    let statusline.="\⚡ %t"
    let statusline.="  « "."%{CWD()}"." »"
    let statusline.="%{fugitive#head()!=''?'\ \ '.fugitive#head().'\ ':''}"
    let statusline.="%{&modified?'\ +\ ':''}"
    let statusline.="%{&readonly?'\ \ ':''}"
    let statusline.="\ %=%-20.(%l/%L,%c%)\ %{&filetype}\ "
    let statusline.="\ "
    let statusline.="%{coc#status()}\ "
    " let statusline.="%{SleuthIndicator()}\ "
    return statusline
endfunction

function! InactiveStatus()
    let statusline=""
    let statusline.="\ %t\ "
    return statusline
endfunction

augroup status
    autocmd!
    autocmd WinEnter * setlocal statusline=%!ActiveStatus()
    autocmd WinLeave,QuickFixCmdPost * setlocal statusline=%!InactiveStatus()
augroup END

set laststatus=2
set statusline=%!ActiveStatus()

" Override color
augroup OverrideColor
    autocmd!
    autocmd ColorScheme * hi! link VertSplit Ignore
    autocmd ColorScheme * hi! link StatusLineNC Ignore
    autocmd ColorScheme * hi! link StatusLine TabLine
    autocmd ColorScheme * hi! link Beacon Cursor
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
nnoremap <Leader>L "ayiw<CR>iconsole.log('<C-R>a: ', <C-R>a);<CR><Esc>

if !exists('g:vscode')
    nnoremap <leader>M :top 11sp term://$SHELL<cr>
    nnoremap <leader>m :below sp term://$SHELL<cr>
endif

" Insert source bin/activate
tnoremap <leader>va source venv/bin/activate<cr>

" Jump to tag
nnoremap <leader>T <C-]>

" Find files
"nnoremap <leader>f :find *

" Find buffer
"nnoremap <leader>b :buffer *
nnoremap <leader>B :ls<CR>:b<Space>
nnoremap <leader>tn :tabnew<CR>

" Next/prev tab
nnoremap <silent> <tab> gt
nnoremap <silent> <s-tab> gT

" Space to fold
nnoremap <space> za

" Quick edit vimrc
nnoremap <leader>ev :e ~/dotfiles/nvimrc<cr>
nnoremap <leader>sv :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>sg :source ~/.config/nvim/ginit.vim<cr>

if WINDOWS()
  nnoremap <leader>ev :e ~\AppData\Local\nvim\init.vim<cr>
  nnoremap <leader>sv :source ~\AppData\Local\nvim\init.vim<cr>
  nnoremap <leader>sg :source ~\AppData\Local\nvim\ginit.vim<cr>
endif

nnoremap <F1> <nop>
nnoremap Q <nop>

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
    autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"
augroup END

" coc-vim
let g:coc_global_extensions = [ 'coc-tsserver',
                              \ 'coc-eslint',
                              \ 'coc-prettier',
                              \ 'coc-tailwindcss',
                              \ 'coc-react-refactor',
                              \ 'coc-css',
                              \ 'coc-json',
                              \ 'coc-pyright',
                              \ 'coc-highlight',
                              \ 'coc-emmet',
                              \ 'coc-ultisnips' ]

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Remap keys for gotos
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>E <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>D <Plug>(coc-codeaction)
xmap <leader>x <Plug>(coc-codeaction-selected)
nmap <leader>x <Plug>(coc-codeaction-selected)

command! -nargs=0 Prettier :CocCommand prettier.formatFile

" fugitive
nnoremap <leader>ch :diffget //2<CR>
nnoremap <leader>cl :diffget //3<CR>
nnoremap <leader>G :vertical Git<CR>

augroup init_quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup END

" Python syntax highlight
let g:python_highlight_all = 1

" Colorscheme
" hard, medium, soft
let g:gruvbox_material_background = 'hard'
" material, mix, original
" let g:gruvbox_material_palette = 'material'
" colorscheme gruvbox-material

" default, atlantis, andromeda, shusia, maia
let g:sonokai_cursor = 'red'

" 'default', 'aura', 'neon'
" let g:edge_style = 'default'
let g:edge_cursor = 'red'

try
  colorscheme edge
catch
  " echo 'Colorscheme not found'
endtry

" fzf
let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_preview_window = ['down:50%', 'ctrl-s']
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.6 } }
let g:fzf_buffers_jump = 0
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" Grepper
nnoremap <Leader>a :Rg 
"Start searching the word under the cursor:
nnoremap <leader>A :Rg <C-R><C-W><cr>

tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
nnoremap <silent><leader>d :Commands<cr>
nnoremap <silent><leader>r :Registers<cr>
nnoremap <silent><leader>v :Buffers<cr>
nnoremap <silent><leader>l :BLines<cr>
" nnoremap <expr><leader>f (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<cr>"
nnoremap <silent><leader>F :Files<cr>
nnoremap <silent><leader>f :GFiles<cr>
nnoremap <leader>V :Windows<cr>

augroup fzfpopupter
  autocmd!
  autocmd FileType fzf exe 'tnoremap <buffer><nowait> <C-j> <Down>'
        \ | tnoremap <buffer><nowait> <C-k> <Up>
augroup END

" CTRL-A CTRL-Q to select all and build quickfix list
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

command! -nargs=* Manage T docker-compose -f local.yml run --rm django python manage.py <args>
command! -nargs=* Test T docker-compose -f local.yml run --rm django pytest <args>
command! PullDotfiles T cd ~/dotfiles; git pull;
command! PushDotfiles T cd ~/dotfiles; git add .; git commit -m "Quick sync"; git push;

" Hop
nmap s :HopChar1<enter>

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
let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\}
" taboo
nnoremap <leader>en :TabooRename 
let taboo_close_tabs_label = "X" 
let taboo_tab_format = " %f%m "
let taboo_renamed_tab_format = " [%l]%m "

" autoclose
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.htmldjango'
let g:closetag_filetypes = 'javascript'

" coc-fzf
let g:coc_fzf_preview = ''
let g:coc_fzf_opts = []

" anyfold
augroup AnyFold
  autocmd Filetype javascript AnyFoldActivate
  autocmd Filetype python AnyFoldActivate
augroup END

" let g:indent_blankline_char_highlight_list = ['Title', 'LineNr', 'MoreMsg', 'Directory', 'Question']
  " char_highlight_list = {
  "     'NonText',
  "     'LineNr',
  " },
lua <<EOF
require('indent_blankline').setup {
  space_char_blankline = ' ',
  buftype_exclude = {'terminal'},
  filetype_exclude = {'help', "startify", 'fugitive', 'git'},
  show_current_context = false,
  show_current_context_start = true,
  show_first_indent_level = false,
  char = '▏',
  char_highlight_list = {
      'Title',
      'LineNr',
      'MoreMsg',
      'Directory',
      'Question',
  },
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
  }
}
require('hop').setup()
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '┃', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '┃', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
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
EOF
