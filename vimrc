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
"se balloonexpr=Balloon() ballooneval
se incsearch ignorecase smartcase
se autoread lazyredraw ttyfast
se diffopt=filler,iwhite
se commentstring=#\%s
se visualbell t_vb=
se guioptions-=r guioptions-=L guioptions-=T
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
    au FileType zsh,sh,bash setlocal sw=2 softtabstop=2
endif

" command mode
" :W will save current file with sudo for when i don't have write permissions
command! -bar -nargs=0 W  silent! exec "write !sudo tee % >/dev/null"  | silent! edit!
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
" remap arrow keys to switch buffers (broken -_-)
map <right> <ESC>:bn<CR>
map <left> <ESC>:bp<CR>
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
" it is so similar to defaul movement keys...
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

" neocomplcache bindings
"im <silent> <expr> <CR> pumvisible() ?
"            \ <CR><C-R>=(col('.')-1&&match(getline(line('.')), '\\.',
"            \ col('.')-2) == col('.')-2)?\"\<lt><C-X>\<lt><C-O>\":\"\"<CR>"
"            \ : "<CR>""
" undo completion
ino <expr> <C-g> neocomplcache#undo_completion()
" complete longest common string from completion list
ino <expr> <C-l> neocomplcache#complete_common_string()
ino <expr> <C-p> pumvisible() ? '<C-p>' :
            \'<C-p><C-r>=pumvisible() ? "\<lt>Up>" : ""<CR>'
ino <expr> <C-n> pumvisible() ? '<C-n>' :
            \'<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
im <expr> <TAB> neocomplcache#sources#snippets_complete#expandable() ?
            \"\<Plug>(neocomplcache_snippets_expand)" :pumvisible() ? 
            \"\<C-n>" : "\<TAB>"
" im <C-k> <Plug>(neocomplcache_snippets_expand) " this didn't work as well as <tab> below
ino <expr> <C-h> neocomplcache#smart_close_popup()."\<C-h>"
ino <expr> <BS> neocomplcache#smart_close_popup()."\<C-h>"
ino <expr> <C-y> neocomplcache#close_popup()
ino <expr> <C-e> neocomplcache#cancel_popup()
smap <C-k> <Plug>(neocomplcache_snippets_expand)

" variable settings
" unset PAGER, so as to make vim handy as a pager
let $PAGER=''
" :TOhtml, don't convert line numbers
let g:html_number_lines = 0
" tskeleton settings for templates
let g:tskelUserEmail = "<j dot s dot mcgee115 at gmail dot com>"
let g:tskelUserName = "Josh McGee"
" allow tskel to use stakeholders plugin
let g:tskeleton#enable_stakeholders = 1
" neocomplcache
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 2
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_enable_auto_select = 1
let javascript_enable_domhtmlcss=1
" python mode extended completion
let pymode_rope_extended_complete=1
" dir where yankring is stored
let g:yankring_history_dir = '$HOME/.cache/vim'
" ultisnips bindings
let g:UltiSnipsExpandTrigger = "<C-tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" use doxygen style comments in snippet
let g:ultisnips_python_style = "doxygen"

" expressions
" determine colorscheme based on TERM
" we don't want 256color when terminfo does not support
if &t_Co > 2 || has("gui_running")
    syntax on
    if (&term =~ 'rxvt-unicode' || &term =~ 'screen-256color')
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
    set guifont=Envy\ Code\ R\ 10
endif

" set foldmethod for files with syntax hiliting 
if has("syntax")
    set foldmethod=syntax
    " set foldmethod for files without syntax hiliting
else 
    set foldmethod=indent
endif

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

if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Automatically create dir to write file to if it doesn't exist
function! AutoMkDir()
    let required_dir = expand("<afile>:p:h")
    if !isdirectory(required_dir)
        if confirm("Directory '" . required_dir . "' doesn't exist.", "&Abort\n&Create it") != 2
            bdelete
            return
        endif

        try
            call mkdir(required_dir, 'p')
        catch
            if confirm("Can't create '" . required_dir . "'", "&Abort\n&Continue anyway") != 2
                bdelete
                return
            endif
        endtry
    endif
endfunction

" delete buffer without closing window
function! Bclose()
    let curbufnr = bufnr("%")
    let altbufnr = bufnr("#")

    if buflisted(altbufnr)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == curbufnr
        new
    endif

    if buflisted(curbufnr)
        execute("bdelete! " . curbufnr)
    endif
endfunction


" some colors
let s:statuscolors = {
            \ 'ModeNormal' : [[ '#4e9a06', '#ffffff', 'bold'], [ ]],
            \ 'ModeInsert' : [[ '#cc0000', '#ffffff', 'bold'], [ ]],
            \ 'FileName' : [[ '#c2bfa5', '#000000', 'bold'], [ '#1c1c1c', '#808080', 'none']],
            \ 'ModFlag' : [[ '#c2bfa5', '#cc0000', 'bold'], [ '#1c1c1c', '#4e4e4e', 'none']],
            \ 'BufFlag' : [[ '#c2bfa5', '#000000', 'none'], [ '#1c1c1c', '#4e4e4e', 'none']],
            \ 'FileType' : [[ '#585858', '#bcbcbc', 'none'], [ '#080808', '#4e4e4e', 'none']],
            \ 'Branch' : [[ '#585858', '#bcbcbc', 'none'], [ '#1c1c1c', '#4e4e4e', 'none']],
            \ 'BranchS' : [[ '#585858', '#949494', 'none'], [ '#1c1c1c', '#4e4e4e', 'none']],
            \ 'FunctionName' : [[ '#1c1c1c', '#9e9e9e', 'none'], [ '#080808', '#4e4e4e', 'none']],
            \ 'FileFormat' : [[ '#1c1c1c', '#bcbcbc', 'bold'], [ '#080808', '#4e4e4e', 'none']],
            \ 'FileEncoding' : [[ '#1c1c1c', '#bcbcbc', 'bold'], [ '#080808', '#4e4e4e', 'none']],
            \ 'Separator' : [[ '#1c1c1c', '#6c6c6c', 'none'], [ '#080808', '#4e4e4e', 'none']],
            \ 'ExpandTab' : [[ '#585858', '#eeeeee', 'bold'], [ '#1c1c1c', '#808080', 'none']],
            \ 'LineNumber' : [[ '#585858', '#bcbcbc', 'bold'], [ '#1c1c1c', '#808080', 'none']],
            \ 'LineColumn' : [[ '#585858', '#bcbcbc', 'none'], [ '#1c1c1c', '#4e4e4e', 'none']],
            \ 'LinePercent' : [[ '#c2bfa5', '#303030', 'bold'], [ '#1c1c1c', '#4e4e4e', 'none']],
            \ 'Warning' : [[ '#cc0000', '#ffffff', 'bold'], [ '#1c1c1c', '#808080', 'none']],
            \ 'Error' : [[ '#585858', '#ff5f00', 'bold'], [ '#1c1c1c', '#4e4e4e', 'none']]
            \ }

function! s:StatusLineColors(colors)
    for name in keys(a:colors)
        let colors = {'c': a:colors[name][0], 'nc': a:colors[name][1]}
        let name = (name == 'NONE' ? '' : name)

        if exists("colors['c'][0]")
            exec 'hi StatusLine' . name .
                        \ ' guibg=' . colors['c'][0] .
                        \ ' guifg=' . colors['c'][1] .
                        \ ' gui=' . colors['c'][2]
        endif

        if exists("colors['nc'][0]")
            exec 'hi StatusLine' . name . 'NC' .
                        \ ' guibg=' . colors['nc'][0] .
                        \ ' guifg=' . colors['nc'][1] .
                        \ ' gui=' . colors['nc'][2]
        endif
    endfor
endfunction

" s:StatusLine() {{{2
function! s:StatusLine(new_stl, type, current)
    let current = (a:current ? "" : "NC")
    let new_stl = a:new_stl

    " Prepare current buffer specific text
    " Syntax: <CUR> ... </CUR>
    let new_stl = substitute(new_stl, '<CUR>\(.\{-,}\)</CUR>', (a:current ? '\1' : ''), 'g')

    " Prepare statusline colors
    " Syntax: #[ ... ]
    let new_stl = substitute(new_stl, '#\[Mode\]', '%#StatusLineMode' . a:type . '#', 'g')
    let new_stl = substitute(new_stl, '#\[\(\w\+\)\]',
                \ '%#StatusLine' . '\1' . current . '#', 'g')

    if &l:statusline ==# new_stl
        " Statusline already set, nothing to do
        return
    endif

    if empty(&l:statusline)
        " No statusline is set, use new_stl
        let &l:statusline = new_stl
    else
        " Check if a custom statusline is set
        let plain_stl = substitute(&l:statusline, '%#StatusLine\w\+#', '', 'g')

        if &l:statusline ==# plain_stl
            " A custom statusline is set, don't modify
            return
        endif

        " No custom statusline is set, use new_stl
        let &l:statusline = new_stl
    endif
endfunction

" Helper functions {{{2
" GetFileName() {{{3
function! GetFileName()
    if &buftype == 'help'
        return expand('%:p:t')
    elseif &buftype == 'quickfix'
        return '[Quickfix List]'
    elseif bufname('%') == ''
        return '[No Name]'
    else
        return expand('%:p:~:.')
    endif
endfunction

" GetState() {{{3
function! GetState()
    if &buftype == 'help'
        return 'H'
    elseif &readonly || &buftype == 'nowrite' || &modifiable == 0
        return '-'
    elseif &modified != 0
        return '*'
    else
        return ''
    endif
endfunction

" GetFileformat() {{{3
function! GetFileFormat()
    if &fileformat == '' || &fileformat == 'unix'
        return ''
    else
        return &fileformat
    endif
endfunction

" GetFileencoding() {{{3
function! GetFileEncoding()
    if empty(&fileencoding) || &fileencoding == 'utf-8'
        return ''
    else
        return &fileencoding
    endif
endfunction

" StatuslineTabWarning() {{{3
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning = 'm'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '!'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction
autocmd CursorHold,BufWritePost * unlet! b:statusline_tab_warning

" StatuslineTrailingSpaceWarning() {{{3
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '·'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction
autocmd CursorHold,BufWritePost * unlet! b:statusline_trailing_space_warning

" Default statusline {{{2
let g:default_stl = ""

let g:default_stl .= "<CUR>#[Mode] "
let g:default_stl .= "%{substitute(mode(), '', '^V', 'g')} "
let g:default_stl .= "%{&paste ? '(paste) ' : ''}"
let g:default_stl .= "</CUR>"

" File name
let g:default_stl .= "#[FileName] %{GetFileName()} "

let g:default_stl .= "#[ModFlag]%(%{GetState()} %)#[BufFlag]%w"

" File type
let g:default_stl .= "<CUR>%(#[FileType] %{!empty(&ft) ? &ft : '--'}#[BranchS]%)</CUR>"

" Spellcheck language
let g:default_stl .= "<CUR>%(#[FileType]%{&spell ? ':' . &spelllang : ''}#[BranchS]%)</CUR>"

" Git branch
let g:default_stl .= "#[Branch]%("
let g:default_stl .= "%{exists('g:loaded_fugitive') ? substitute(fugitive#statusline(), '\\[GIT(\\([a-z0-9\\-_\\./:]\\+\\))\\]', '<CUR>:</CUR>\\1', 'gi') : ''}"
let g:default_stl .= "%) "

" Syntastic
"let g:default_stl .= "<CUR>%(#[BranchS][>] #[Error]%{substitute(SyntasticStatuslineFlag(), '\\[Syntax: line:\\(\\d\\+\\) \\((\\(\\d\\+\\))\\)\\?\\]', '[>][>][>] SYNTAX \\1 \\2 [>][>][>]', 'i')} %)</CUR>"
"let g:default_stl .= "<CUR>%(#[BranchS][>] #[Error]%{substitute('[Syntax: line:42 (99)]', '\\[Syntax: line:\\(\\d\\+\\) \\((\\(\\d\\+\\))\\)\\?\\]', 'SYNTAX \\1 \\2', 'i')} %)</CUR>"

" Padding/HL group
let g:default_stl .= "#[FunctionName] "

" Truncate here
let g:default_stl .= "%<"

" Current directory
let g:default_stl .= "%{fnamemodify(getcwd(), ':~')}"

" Right align rest
let g:default_stl .= "%= "

" File format
let g:default_stl .= '<CUR>%(#[FileFormat]%{GetFileFormat()} %)</CUR>'

" File encoding
let g:default_stl .= '<CUR>%(#[FileFormat]%{GetFileEncoding()} %)</CUR>'

" Tabstop/indent/whitespace settings
let g:default_stl .= "#[ExpandTab] "

let g:default_stl .= "%(#[Warning]"
let g:default_stl .= "%{StatuslineTrailingSpaceWarning()}"
let g:default_stl .= "%{StatuslineTabWarning()}"
let g:default_stl .= "#[ExpandTab] %)"

let g:default_stl .= "%{&expandtab ? 'S' : 'T'}"
let g:default_stl .= "#[LineColumn]:%{&tabstop}:%{&softtabstop}:%{&shiftwidth}"

" Unicode codepoint
let g:default_stl .= '<CUR>#[LineNumber] U+%04B</CUR>'

" Line/column/virtual column, Line percentage
let g:default_stl .= "#[LineNumber] %04(%l%)#[LineColumn]:%03(%c%V%) "

" Line/column/virtual column, Line percentage
let g:default_stl .= "#[LinePercent] %p%%"

" Current syntax group
"let g:default_stl .= "%{exists('g:synid') && g:synid ? '| '.synIDattr(synID(line('.'), col('.'), 1), 'name').' ' : ''}"

" highlight characters starting at column 80
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%80v.\+/
if exists('+colorcolumn')
    highlight ColorColumn ctermbg=darkgrey
    set colorcolumn=0
    " toggle colorcolumn
    let s:color_column_old = "5,9,13,17,21,25,80"
    function! s:ToggleMargin()
        if s:color_column_old == 0
            let s:color_column_old = &colorcolumn
            windo let &colorcolumn = 0
        else
            windo let &colorcolumn = s:color_column_old
            let s:color_column_old = 0
        endif
    endfunction
endif
nmap <leader>M :call <SID>ToggleMargin()<CR>

" Autocommands {{{2
augroup StatusLineHighlight
    autocmd!

    au ColorScheme * call <SID>StatusLineColors(s:statuscolors)

    au BufEnter,BufWinEnter,WinEnter,CmdwinEnter,CursorHold,BufWritePost,InsertLeave * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 1)
    au BufLeave,BufWinLeave,WinLeave,CmdwinLeave * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 0)
    au InsertEnter,CursorHoldI * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Insert', 1)
augroup END

