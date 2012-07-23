function! SyntaxBalloon()
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
        return SyntaxBalloon()
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

" highlight characters starting at column 72
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%72v.\+/
if exists('+colorcolumn')
    highlight ColorColumn ctermbg=darkgrey
    set colorcolumn=0
    " toggle colorcolumn
    let s:color_column_old = "5,9,13,17,21,25,72"
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


