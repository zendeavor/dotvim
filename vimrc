" initial options to make things work right
se nocp
filetype off
call pathogen#infect()
call pathogen#helptags()

" settings
se backup backupdir=~/.vim/backups dir=~/.vim/tmp undofile undodir=~/.vim/undo
se foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo
se backspace=2 cmdheight=1 laststatus=2 relativenumber showbreak=»
se scrolloff=999 sidescroll=50 listchars+=precedes:<,extends:> 
se showcmd showmode ruler cpoptions+=n$ shortmess+=atTWI more
se shiftround preserveindent smartindent autoindent cindent
se tabstop=8 shiftwidth=4 softtabstop=4 expandtab smarttab
se ff=unix fileencoding=utf-8 encoding=utf-8
se formatprg=par\ -w79r pastetoggle=<f10>
se wildmenu wildmode=list:longest,full
se completeopt=longest,menuone,preview
se balloonexpr=Balloon() ballooneval
se incsearch ignorecase smartcase
se autoread lazyredraw ttyfast
se diffopt=filler,iwhite
se commentstring=#\%s
se visualbell t_vb=
se virtualedit=all
se hidden

"highlight Pmenu ctermbg=238 gui=bold

" autocommands
au!
if has("autocmd")
    filetype plugin indent on

    au BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
    " fill out new python scripts with template
    au BufNewFile *.py TSkeletonSetup template.py
    " set cwd to dir of current file in open buffer
    au BufEnter * silent! lcd %:p:h:gs/ /\\ /
    " make scripts starting with a shebang executable after saving
    au BufWritePost * 
                \ if getline(1) =~ "^#!" | 
                \   exec 'silent !chmod u+x <afile>' | 
                \ endif
    " write out changes to a file when focus is lost from that buffer
    au FocusLost * :wa
    " source vimrc right after it is saved to test changes
    au BufWritePost $MYVIMRC so $MYVIMRC
    " set commentstring for vim's filetype    
    au FileType vim setlocal commentstring=\"%s
    " set commentstring for php filetype
    au FileType php setlocal commentstring=//%s
    " set tabs up for shell files
    au FileType zsh,sh setlocal sw=2 softtabstop=2
endif

" command mode
" :W will save current file with sudo for when i don't have write permissions
command! -bar -nargs=0 W silent! exec "write !sudo tee % >/dev/null"  | silent! edit!
" :Wrap will softwrap a file safely
command! -nargs=* Wrap set wrap linebreak nolist

" mappings
" change leader key from \ (backslash) to , (comma)
let mapleader = ","
" substitute ctrl-e in visual mode for comma because ctrl-e is useless
" and comma might be handy when i learn what it does 
vn <c-e> ,
" source/edit vimrc
nn <leader>vs :source $MYVIMRC<CR>:filetype detect<CR>:echo 'vimrc reloaded'<CR>
nn <leader>ve :tabedit $MYVIMRC<CR>
" open a new empty file in cwd
nn <leader>e :enew<CR>
" paste from X clipboard <broken?>
map <silent> <leader>p "+p
map <silent> <leader>P "+P
" return to normal mode with jj 
cno jj <c-c>
ino jj <esc>
" ctrl-c claw hand sucks
ino <leader>; <c-c>
" change search mode to use <python/perl??> style regex
nn / /\v
vn / /\v
" reselect text when indenting in visual and ex modes
vn < <gv
vn > >gv
xn > >gv
xn < <gv
" tap v to return to normal mode
vn v <esc>
" open/close quickfix window
nn <silent> <leader>qo :copen<CR>
nn <silent> <leader>qc :cclose<CR>
" window movement
nn <leader>w <C-w>v<C-w>l
nn <c-j> <c-w>j
nn <c-k> <c-w>k
nn <c-l> <c-w>l
nn <c-h> <c-w>h
" this was for a smart reason, but i forget why because
" it is so similar to default movement keys...
nn j gj
nn k gk
" reverse colon and semi-colon because colon
" enters command mode, which is much more common
" than whatever semi-colon is used for
nn ; :
nn : ;
" show indent guide
nn <silent> <leader><bar> :call ToggleIndentGuidesTabs()<cr>
nn <silent> <leader><bslash> :call ToggleIndentGuidesSpaces()<cr>
" show yankring
nn <silent> <leader>y :YRShow<CR>
" use ack to search
nn <leader>sa :Ack<space>

" fuzzyfinder mappings
nn <leader>f :FufFileWithCurrentBufferDir<CR>
nn <leader>b :FufBuffer<CR>
nn <leader>t :FufTaggedFile<CR>

" trinity toggles
nn <F8>   :TrinityToggleAll<CR>
nn <F9>   :TrinityToggleSourceExplorer<CR>
nn <F7>   :TrinityToggleTagList<CR>
nn <F11>  :TrinityToggleNERDTree<CR> 


" variable settings
" open text files from pastebins 
let g:netrw_http_cmd = "curl"
let g:netrw_http_xcmd = "-so"
" :TOhtml, don't convert line numbers
let g:html_number_lines = 0
" tskeleton settings for templates
let g:tskelUserEmail = "<j dot s dot mcgee115 at gmail dot com>"
let g:tskelUserName = "Josh McGee"
" allow tskel to use stakeholders plugin
let g:tskeleton#enable_stakeholders = 1
" dir where yankring is stored
let g:yankring_history_dir = '$HOME/.cache/vim'
" ultisnips bindings
" let g:UltiSnipsExpandTrigger = "<C-tab>"
" let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" path to snippets dirs, relative to ~/.vim
let g:UltiSnipsSnippetDirectories = ["bundle/ultisnips/UltiSnips"]
" which python version to use
let g:UltiSnipsUsePythonVersion = 3
" use doxygen style comments in snippet
let g:ultisnips_python_style = "doxygen"

" expressions
" determine colorscheme based on TERM
" we don't want 256color when terminfo does not support
if &t_Co > 2 || has("gui_running")
    syntax on
    if (&term =~ '*256color')
        set t_Co=256
    endif
    if  &t_Co == 256
        colorscheme wombat256mod
    else
        colorscheme desert
    endif
endif

" set font and colorscheme for gvim
if has("gui_running")
    set guioptions=acM
    set guifont=Consolas\ 9
endif

" set foldmethod for files with syntax hiliting 
if has("syntax")
    set foldmethod=syntax
else 
    " set foldmethod for files without syntax hiliting
    set foldmethod=indent
endif

