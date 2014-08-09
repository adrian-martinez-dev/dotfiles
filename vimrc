" Entorno ---------------------------------

set nocompatible              " be iMproved
set modelines=0

filetype on
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My bundles here: ----------------------------
" General
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'terryma/vim-smooth-scroll'
Plugin 'bling/vim-airline'
Plugin 'nanotech/jellybeans.vim'
Plugin 'mklabs/vim-fetch'
Plugin 'reedes/vim-colors-pencil'
Plugin '29decibel/codeschool-vim-theme'
Plugin 'twerth/ir_black'
Plugin 'justinmk/vim-gtfo'
Plugin 'jonathanfilip/vim-lucius'
Plugin 'fmoralesc/vim-vitamins'
Plugin 'Yggdroot/indentLine'
Plugin 'edkolev/tmuxline.vim'
Plugin 'jtai/vim-womprat'

"Programacion
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'Valloric/MatchTagAlways'

"Snippets & AutoComplete"
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

"Python
Plugin 'klen/python-mode'
Plugin 'python.vim'
Plugin 'python_match.vim'
Plugin 'tpope/vim-markdown'

"Bootstrap 3 snippets
Plugin 'chrisgillis/vim-bootstrap3-snippets'

call vundle#end()            " required
filetype plugin indent on     " required!

" General ---------------------------------

set background=dark         " Assume a dark background
syntax on                   " Syntax highlighting
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing
scriptencoding utf-8
set clipboard=unnamedplus

autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
" Always switch to the current file directory

set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set virtualedit=onemore             " Allow for cursor beyond last character
set history=1000                    " Store a ton of history (default is 20)
set nospell                         " Spell checking off
set hidden                          " Allow buffer switching without saving
set nofoldenable                    "Disable folding
set wildmenu " cmd line completion a-la zsh
set wildmode=list:longest " matches mimic that of bash or zsh
set wildignore+=node_modules " node_modules dir
set wildignore+=.ropeproject " py rope cache dir
set wildignore+=.hg,.git,.svn " Version control
set wildignore+=*.aux,*.out,*.toc " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl " compiled spelling word lists
set wildignore+=*.sw? " Vim swap files
set wildignore+=*.DS_Store " OSX bullshit
set wildignore+=migrations " Django migrations
set wildignore+=*.pyc " Python byte code
set wildignore+=*.class " Java byte code

au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Restore cursor to file position in previous editing session
function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

" Keep search matches in the middle of the window
nnoremap n nzzzv
nnoremap N Nzzzv

" Setting up the directories ---------------------------------

set noswapfile
set backup               " Backups are nice ...
if has('persistent_undo')
   set undofile                " So is persistent undo ...
   set undolevels=1000         " Maximum number of changes that can be undone
   set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

let mapleader = ","

" Vim UI -------------------------------------
set lines=999 columns=999    " Start maximized
"set colorcolumn=81     " Highlight column at 80
set number
set wrap
set linebreak
set title
set nolist
set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
colorscheme womprat

set lazyredraw
set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode
"set cursorline                  " Highlight current line
set hlsearch                    " Highlight search matches
hi CursorLine ctermbg=234 ctermfg=15 " 8 = dark gray, 15 = white
hi Cursor ctermbg=15 ctermfg=234

"hi Normal ctermbg=NONE

if has('statusline')
    set laststatus=2
    " Broken down into easily includeable segments
    set statusline=%<%f\                    "Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set showmatch                   " show matching brackets/parenthesis
set incsearch                   " Find as you type search
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
"set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=5                 " Minimum lines to keep above and below cursor
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" Formatting
set list lcs=tab:\|\            " show indent lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
let loaded_matchparen = 1
"set matchpairs+=<:>             " Match, to be used with %
"set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
"set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks

"Omnicompletion

autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown set omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby set omnifunc=rubycomplete#Complete
autocmd FileType htmldjango set omnifunc=htmldjangocomplete#CompleteDjango

"Key remapping -------------------------------------
"Ctr+C, Ctrl+V keys to copy paste
nmap <C-V> "+gP
imap <C-V> <ESC><C-V>i
vmap <C-C> "+y

nnoremap <F1> <nop>
nnoremap Q <nop>
nnoremap K <nop>

"Preview file on browser
nnoremap <F12>f :exe ':silent !firefox %'<CR>
nnoremap <F12>c :exe ':silent !chromium-browser %'<CR>
nnoremap <F12>g :exe ':silent !google-chrome %'<CR>

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" Same for 0, home, end, etc
noremap $ g$
noremap <End> g<End>
noremap 0 g0
noremap <Home> g<Home>
noremap ^ g^

" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>



 " Shortcuts--------------------------------------
" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
" Change Working Directory to that of the current file cmap cwd lcd %:p:h cmap cd. lcd %:p:h 
" Visual shifting (does not exit Visual mode) vnoremap < <gv vnoremap > >gv 
" Allow using the repeat operator with a visual selection (!) 
" http://stackoverflow.com/a/8064607/127816 vnoremap . :normal .<CR> 
" Fix home and end keybindings for screen, particularly on mac 
" - for some reason this fixes the arrow keys too. huh. map [F $ imap [F $ map [H g0 imap [H g0 
" For when you forget to sudo.. Really Write the file. cmap w!! w !sudo tee % >/dev/null 
" Some helpers to edit mode " http://vimcasts.org/e/14 cnoremap %% <C-R>=expand('%:h').'/'<cr> map <leader>ew :e %% map <leader>es :sp %%

map <leader>ev :vsp %%
map <leader>et :tabe %%

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" Easier horizontal scrolling
map zl zL
map zh zH

" fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

"Plugins
let g:NERDShutUp=1

let b:match_ignorecase = 1

"Syntastic ================================
let g:syntastic_javascript_checkers = ['jshint'] 
let g:syntastic_html_checkers = ['w3']
let g:syntastic_java_checkers = ['javac']
let g:syntastic_java_javac_classpath = "./lib/*.jar\n./src"
""let g:EclimFileTypeValidate = 0
let g:syntastic_mode_map = {'mode': 'passive'}

"NerdTree
map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\.class', '\~$', '\.swo$', '\.swp$', '\.hg', '\.svn', '\.bzr']
"If it is set to 0 then the CWD is never changed by the NERD tree.

"If set to 1 then the CWD is changed when the NERD tree is first loaded to the
"directory it is initialized in. For example, if you start the NERD tree with >
"    :NERDTree /home/marty/foobar
"then the CWD will be changed to /home/marty/foobar and will not be changed
"again unless you init another NERD tree with a similar command.

"If the option is set to 2 then it behaves the same as if set to 1 except that
"the CWD is changed whenever the tree root is changed. For example, if the CWD
"is /home/marty/foobar and you make the node for /home/marty/foobar/baz the new
"root then the CWD will become /home/marty/foobar/baz.
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=0
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

"JSON
nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>

" ctrlp
let g:ctrlp_working_path_mode = 'ra'
nnoremap <silent> <D-t> :CtrlP<CR>
nnoremap <silent> <D-r> :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|pyc|class)$',
  \ }

"Indentline ===========================================================
"let g:indentLine_color_term = 16
let g:indentLine_color_term = 236
let g:indentLine_char = '│'
"let g:indentLine_char = '┊'
let g:indentLine_faster = 1
"let g:indentLine_noConcealCursor = 1 

"=======================================================================
" PythonMode 
" Disable if python support not present
if !has('python')
    let g:pymode = 1
endif
"Turn off the run code script  
let g:pymode_run = 0
let g:pymode_lint_checker = "pyflakes"
let g:pymode_utils_whitespaces = 0
let g:pymode_options = 0
let g:pymode_lint_on_write = 0
"=======================================================================

" Fugitive 
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
nnoremap <silent> <leader>gg :SignifyToggle<CR>

" vim-airline 
" Set configuration options for the statusline plugin vim-airline.
" Use the powerline theme and optionally enable powerline symbols.
" To use the symbols , , , , , , and .in the statusline
let g:airline_theme = 'powerlineish'
let g:airline_powerline_fonts=1
" If the previous symbols do not render for you then install a
" powerline enabled font.

"Configure whether buffer numbers should be shown
"let g:airline#extensions#tabline#buffer_nr_show = 1

"Correcion de los caracters extraños (espacios en blanco)
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

"Desactivar la deteccion de espacios en blanco
let g:airline#extensions#whitespace#enabled = 0

"Activar tabline
let g:airline#extensions#tabline#enabled = 1

"Enable syntastic integration
let g:airline#extensions#syntastic#enabled = 1

"Enable eclim integration
"let g:airline#extensions#eclim#enabled = 0

"Desplegar solo el nombre de archivo en el tab
let g:airline#extensions#tabline#fnamemod = ':t'

"Full path and filename
let g:airline_section_c = '%<%F'

"Desactivar bufferline dentro de airline
"let g:airline#extensions#bufferline#enabled = 0

"Buffer switching mappings
"left/right arrows to switch buffers in normal mode
map <right> :bn<cr>
map <left> :bp<cr>

"=================================================================
"let g:airline#extensions#tmuxline#enabled = 0
let g:tmuxline_preset = 'tmux'

"Eliminar retardo al pasar de Insert a Normal ==================
set timeoutlen=1000 ttimeoutlen=0

"No delay between Insert and Normal mode
augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
augroup END

" GUI Settings  ====================================

" GVIM- (here instead of .gvimrc)
if has('gui_running')
    set guioptions-=T           " Remove the toolbar
    set guioptions-=m           " Remove the menubar
    set guioptions-=L           " Remove nerdtree scroll
    set guioptions-=r           " Remove the scroll bar
    nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
    nnoremap <C-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
    nnoremap <C-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>
    set wrap
    set lines=999 columns=999    " Start maximized
    set lazyredraw
    colorscheme jellybeans
"   set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 14
    set guifont=Inconsolata\ for\ Powerline\ 14
endif

" YouCompleteMe=======================================================

"Cerrar la ventana de previsualizacion despues del completado semantico
"de funciones
let g:ycm_autoclose_preview_window_after_completion = 1

"Cerrar la ventana de previsualizacion despues de salir del modo Insert
"Default 0
let g:ycm_autoclose_preview_window_after_insertion = 0

"Compatibilidad con python mode (autocompletado correcto despues de .)
let g:pymode_rope_complete_on_dot = 0

"Youcompleteme eclim 
"let g:EclimCompletionMethod = 'omnifunc'

" UltiSnips===========================================================

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

"=====================================================================

"vim-browser-reload-linux

"Depends on xdotool
"browser reload:

":ChromeReload <regex>      //reload Google Chrome with optional regex for window title
":FirefoxReload     //reload Firefox
":OperaReload       //reload Opera
":AllBrowserReload  //reload all browser

"start auto reload:

":ChromeReloadStart
":FirefoxReloadStart
":OperaReloadStart
":AllBrowserReloadStart

"stop auto reload:

":ChromeReloadStop
":FirefoxReloadStop
":OperaReloadStop
":AllBrowserReloadStart

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" Initialize directories {
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir', }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    " To specify a different directory in which to place the vimbackup,
    " vimviews, vimundo, and vimswap files/directories, add the following to
    " your .vimrc.before.local file:
    "directory = $HOME . '/.vim/'

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

 "Initialize NERDTree as needed {
function! NERDTreeInitAsNeeded()
    redir => bufoutput
    buffers!
    redir END
    let idx = stridx(bufoutput, "NERD_tree")
    if idx > -1
        NERDTreeMirror
        NERDTreeFind
        wincmd l
    endif
endfunction
