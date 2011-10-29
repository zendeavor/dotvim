call pathogen#infect()
let $PAGER=''

" global vim settings
filetype off
set nocp
if has("autocmd")
    " Enable filetype detection
    filetype plugin indent on
        
    " Restore cursor position
    autocmd BufReadPost *
        \ if line("'\"""'") > 1 && line("'\"""'") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
endif
if &t_Co > 2 || has("gui_running")
    " Enable syntax highlighting
    syntax on
    if &term == 'rxvt-unicode' || &term == 'screen-256color'
        set t_Co=256
    endif
    if  &t_Co == 256
        colorscheme mustang
    else
        colorscheme desert
    endif
endif
if has("syntax")
    set foldmethod=syntax
else 
    set foldmethod=indent
endif
highlight Pmenu ctermbg=238 gui=bold
set mouse=a
set formatprg=par\ -w79r
set backup backupdir=~/.vim/backups dir=~/.vim/tmp
set undofile undodir=~/.vim/undo
set tabstop=8 shiftwidth=4 softtabstop=4 expandtab smarttab
set shiftround preserveindent
set smartindent autoindent cindent
set showcmd showmode ruler more
set autoread lazyredraw ttyfast
set incsearch nohlsearch smartcase
set lbr ff=unix
set diffopt=filler,iwhite
set visualbell t_vb=
set scrolloff=5 wrap
set wildmenu wildmode=list:longest,full
set completeopt=longest,menuone,preview
set backspace=2
set fileencoding=utf-8 encoding=utf-8
set shortmess+=atTWI
set relativenumber
set gdefault
set colorcolumn=80
set statusline=%F%m%r%h%w\
\ ft:%{&ft}\ \
\ff:%{&ff}\ \
\%{strftime(\"%a\ %d/%m/%Y\ \
\%H:%M:%S\",getftime(expand(\"%:p\")))}%=\ \
\buf:%n\ \
\L:%04l\ C:%04v\ \
\T:%04L\ HEX:%03.3B\ ASCII:%03.3b\ %P
set laststatus=2
set cmdheight=1

autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /

" global bindings
let mapleader = ","
nnoremap <leader>s :Ack
nnoremap <leader>w <C-w>v<C-w>l
nnoremap / /\v
vnoremap / /\v
nmap <leader>f :FufFileWithCurrentBufferDir<CR>
nmap <leader>b :FufBuffer<CR>
nmap <leader>t :FufTaggedFile<CR>
map <leader>0 :source $MYVIMRC<CR>
""imap <silent> <expr> <buffer> <CR> pumvisible() ?\
""\<CR><C-R>=(col('.')-1&&match(getline(line('.')), '\\.',\
""\ col('.')-2) == col('.')-2)?\"\<lt><C-X>\<lt><C-O>\":\"\"<CR>"
""\ : "<CR>"
cmap w!! %!sudo tee > /dev/null %
map <right> <ESC>:bn<RETURN>
map <left> <ESC>:bp<RETURN>
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l
nmap <c-h> <c-w>h
nnoremap j gj
nnoremap k gk
noremap <Space> <C-f>
noremap - <C-b>
noremap <Backspace> <C-y>
noremap <Return> <C-e>
vnoremap < <gv
vnoremap > >gv
inoremap jj <esc>
vnoremap v <esc>
nnoremap <F5> :GundoToggle<CR>
" neocomplcache stuff - uber autocomplete
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 2
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
"let g:neocomplcache_dictionary_filetype_lists = {
"\ 'default' : '',
"\ 'vimshell' : $HOME.'/.vimshell_hist',
"\ 'scheme' : $HOME.'/.gosh_completions'
"\ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType c setlocal omnifunc=ccomplete#Complete

" Enable heavy omni completion.
"if !exists('g:neocomplcache_omni_patterns')
"let g:neocomplcache_omni_patterns = {}
"endif
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
"let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" Open and close all the three plugins on the same time
nmap <F8>   :TrinityToggleAll<CR>

" Open and close the srcexpl.vim separately
nmap <F9>   :TrinityToggleSourceExplorer<CR>

" Open and close the taglist.vim separately
nmap <F10>  :TrinityToggleTagList<CR>

" Open and close the NERD_tree.vim separately
nmap <F11>  :TrinityToggleNERDTree<CR> 

" show indent levels
nmap <silent> <leader><bar> :call ToggleIndentGuidesTabs()<cr>
nmap <silent> <leader><bslash> :call ToggleIndentGuidesSpaces()<cr>

function! ToggleIndentGuidesTabs()
    if exists('b:iguides_tabs')
        setlocal nolist
        let &l:listchars = b:iguides_tabs
        unlet b:iguides_tabs
    else
        let b:iguides_tabs = &l:listchars
        setlocal listchars=tab:┆\ "protect the space
        setlocal list
    endif
endfunction

function! ToggleIndentGuidesSpaces()
    if exists('b:iguides_spaces')
        call matchdelete(b:iguides_spaces)
        unlet b:iguides_spaces
    else
        let pos = range(1, &l:textwidth, &l:shiftwidth)
        call map(pos, '"\\%" . v:val . "v"')
        let pat = '\%(\_^\s*\)\@<=\%(' . join(pos, '\|') . '\)\s'
        let b:iguides_spaces = matchadd('CursorLine', pat)
    endif
endfunction


" unfolds on mouseover
function! SyntaxBallon()
    let synID   = synID(v:beval_lnum, v:beval_col, 0)
    let groupID = synIDtrans(synID)
    let name    = synIDattr(synID, "name")
    let group   = synIDattr(groupID, "name")
    return name . "\n" . group
endfunction

function! FoldBalloon()
    let foldStart = foldclosed(v:beval_lnum)
    let foldEnd   = foldclosedend(v:beval_lnum)
    let lines = []
    if foldStart >= 0
        " we are in a fold
        let numLines = foldEnd - foldStart + 1
        if (numLines > 17)
            " show only the first 8 and the last 8 lines
            let lines += getline(foldStart, foldStart + 8)
            let lines += [ '-- Snipped ' . (numLines - 16) . ' lines --']
            let lines += getline(foldEnd - 8, foldEnd)
        else
            " show all lines
            let lines += getline(foldStart, foldEnd)
        endif
    endif
    " return result
    return join(lines, has("balloon_multiline") ? "\n" : " ")
endfunction

function! Balloon()
    if foldclosed(v:beval_lnum) >= 0
        return FoldBalloon()
    else
        return SyntaxBallon()
endfunction

set balloonexpr=Balloon()
set ballooneval


" vimrc stuff
nmap <leader>v :tabedit $MYVIMRC<CR>
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" pymode settings
let pymode_rope_extended_complete=1

"------ Filetypes ------"

" Vimscript
autocmd FileType vim setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

" Shell
autocmd FileType sh setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

" Lisp
autocmd Filetype lisp,scheme setlocal equalprg=~/.vim/bin/lispindent.lisp expandtab shiftwidth=2 tabstop=8 softtabstop=2

" Ruby
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" PHP
autocmd FileType php setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" X?HTML & XML
autocmd FileType html,xhtml,xml setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" CSS
autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" JavaScript
" autocmd BufRead,BufNewFile *.json setfiletype javascript
autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
let javascript_enable_domhtmlcss=1

" Python
au FileType python setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" gvim special settings
set guicursor=a:blinkon0
if has("gui_running")
    colorscheme cloudsmidnight
endif

" autocmds
au FocusLost * :wa

" skeleon stuff
let g:tskelUserEmail = "j.s.mcgee115@gmail.com"
let g:tskelUserName = "Josh McGee"
let g:tskeleton#enable_stakeholders = 1
au BufNewFile *.py TSkeletonSetup template.py
