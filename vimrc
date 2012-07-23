" vim: ft=vim
" initial options to make things work right
se nocp
filetype off
call pathogen#infect()
filetype plugin indent on

" settings
se backup backupdir=~/.vim/backups dir=~/.vim/tmp undofile undodir=~/.vim/undo
se foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo
se autoindent
se backspace=2 
se cmdheight=1 
se laststatus=2 
se relativenumber 
se showbreak=»
se scrolloff=999 sidescroll=50 
se listchars=precedes:<,extends:>,tab:\|-,trail:· list
se showcmd showmode ruler cpoptions+=n$ shortmess+=atTWI more
se ff=unix fileencoding=utf-8 encoding=utf-8
se formatprg=par\ -w79r 
se pastetoggle=<f10>
se wildmenu wildmode=list:longest,full
se completeopt=longest,menuone,preview
se balloonexpr=Balloon() ballooneval
se incsearch ignorecase smartcase
se autoread lazyredraw ttyfast
se diffopt=filler,iwhite
se commentstring=#\%s
se visualbell t_vb=
se nf+=alpha
se virtualedit=all
se shiftround
se hidden
se ofu=syntaxcomplete#Complete
se cscopequickfix=s-,c-,d-,i-,t-,e-

"highlight Pmenu ctermbg=238 gui=bold

" autocommands
au!
if has("autocmd")

    au BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
    " fill out new python scripts with template
    au BufNewFile *.py TSkeletonSetup template.py
    " set cwd to dir of current file in open buffer
    au BufEnter * silent! lcd %:p:h:gs/ /\\ /
    " make scripts starting with a shebang executable after saving
    " au BufWritePost * 
    "             \ if getline(1) =~ "^#!" | 
    "             \   exec 'silent !chmod u+x <afile>' | 
    "             \ endif
    " write out changes to a file when focus is lost from that buffer
    au FocusLost * :wa
    " source vimrc right after it is saved to test changes
    au BufWritePost $MYVIMRC so $MYVIMRC
    au FileType vim setlocal commentstring=\"%s sw=2 sts=2
    au FileType php,c setlocal commentstring=//%s sw=4 tabstop=4
    au FileType php,c let b:delimitMate_eol_marker = ";"
    au FileType zsh,sh setlocal sw=2 softtabstop=2
endif              

if has("cscope")
  set csprg=cscope
  set csto=0
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
    " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set csverb
  map g<C-]> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
  map g<C-\> :cs find 0 <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

  " Using 'CTRL-spacebar' then a search type makes the vim window
  " split horizontally, with search result displayed in
  " the new window.

  nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>

  " Hitting CTRL-space *twice* before the search type does a vertical
  " split instead of a horizontal one

  nmap <C-Space><C-Space>s
	  \:vert scs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-Space><C-Space>g
	  \:vert scs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-Space><C-Space>c
	  \:vert scs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-Space><C-Space>t
	  \:vert scs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <C-Space><C-Space>e
	  \:vert scs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-Space><C-Space>i
	  \:vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-Space><C-Space>d
	  \:vert scs find d <C-R>=expand("<cword>")<CR><CR>
endif

" command mode
" :W will save current file with sudo for when i don't have write permissions
command! -bar -nargs=0 W silent! exec "write !sudo dd of=% >/dev/null"  | silent! edit!
" :Wrap will softwrap a file safely
command! -nargs=* Wrap set wrap linebreak nolist

" mappings
" change leader key from \ (backslash) to , (comma)
let mapleader = ","                 
" substitute ctrl-e in visual mode for comma because ctrl-e is useless
vn <c-e> ,
" make yanking with Y more logical (like D)
nn Y y$
" source/edit vimrc
nn <leader>vs :source $MYVIMRC<cr> | filetype detect
nn <leader>ve :tabedit $MYVIMRC<CR> | filetype detect
" syntax highlighting doesn't always automagic
nn <leader>fd :filetype detect<cr>
" open a new empty file in cwd
nn <leader>e :enew<CR>
" paste from X clipboard 
map <silent> <leader>p "*p
map <silent> <leader>P "*P
" return to normal mode with jj 
cno jj <c-c>
ino jj <esc>
" ctrl-c claw hand sucks
ino <leader>, <c-c>
" tap v to return to normal mode
vn v <esc>
" open/close quickfix window
nn <silent> <leader>o :copen<CR>
nn <silent> <leader>c :cclose<CR>
" window movement
nn <leader>w <C-w>v<C-w>l
nn <c-j> <c-w>j
nn <c-k> <c-w>k
nn <c-l> <c-w>l
nn <c-h> <c-w>h
" move through virtual lines, rows as determined by terminal even if wrapped
nn j gj
nn k gk
" and when those wrapped lines are massive, do this!
nn gj j
nn gk k
" reverse colon and semi-colon because colon
" enters command mode, which is much more common
nn ; :
" semi-colon is still useful though, so let's keep it around
nn : ;
" show indent guide
nn <silent> <leader><bar> :call ToggleIndentGuidesTabs()<cr>
nn <silent> <leader><bslash> :call ToggleIndentGuidesSpaces()<cr>
" use ack to search
nn <leader>sa :Ack<space>
" some niceties for using a couple z commands
vnoremap <silent> zz :<C-u>call setpos('.',[0,(line("'>")-line("'<"))/2+line("'<"),0,0])<Bar>normal! zzgv<CR>
vnoremap <silent> zt :<C-u>call setpos('.',[0,line("'<"),0,0])<Bar>normal! ztgv<CR>
vnoremap <silent> zb :<C-u>call setpos('.',[0,line("'>"),0,0])<Bar>normal! zbgv<CR>


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
let g:UltiSnipsExpandTrigger = "<C-tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" path to snippets dirs, relative to ~/.vim
let g:UltiSnipsSnippetDirectories = ["bundle/ultisnips/UltiSnips"]
" which python version to use
let g:UltiSnipsUsePythonVersion = 3
" use doxygen style comments in snippet
" let g:ultisnips_python_style = "doxygen"

" expressions
" determine colorscheme based on TERM
" we don't want 256color when terminfo does not support
if (&term =~ 256) || has("gui_running")
    syntax on
    colorscheme neverland-darker
else
    colorscheme desert
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

