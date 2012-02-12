" Vim global plugin for Pastefire (http://pastefire.com/)
" Last Change: 2012 Feb 12
" Maintainer: delphinus <delphinus@remora.cx>
" License: This file is placed in th public domain.

let s:save_cpo = &cpo
set cpo&vim

function! pastefire#run(str, line1, line2)
    " account setting
    if exists('$PASTEFIRE_EMAIL') && len($PASTEFIRE_EMAIL) > 0
        let email = $PF_EMAIL
    elseif exists('g:pastefire_email') && len(g:pastefire_email) > 0
        let email = g:pastefire_email
    else
        echomsg 'please specify $PASTEFIRE_EMAIL or g:pastefire_email'
        return
    endif

    " password setting
    if exists('$PASTEFIRE_PASSWORD') && len($PASTEFIRE_PASSWORD) > 0
        let password = $PF_PASSWORD
    elseif exists('g:pastefire_password') && len(g:pastefire_password) > 0
        let password = g:pastefire_password
    else
        echomsg 'please specify $PASTEFIRE_PASSWORD or g:pastefire_password'
        return
    endif

    let ary = split(a:str)
    let lines = []
    " in normal mode, this gets a line on cursor.
    if get(ary, 0) ==# 'n'
        let lines = [getline('.')]

    " in visual mode, this gets lines on selection.
    elseif get(ary, 0) ==# 'v'
        let start_line = getpos("'<")
        let end_line = getpos("'>")
        let save_cursor = getpos('.')
        call setpos('.', [0, end_line[1], 1, 0])

        " if you select strings in a line,
        if start_line[1] == end_line[1]
            let src = getline(start_line[1])
            let start = start_line[2] - 1
            let len = end_line[2] - start_line[2] + 1
            let lines = [strpart(src, start, len)]

        " if you select in 'V' mode
        elseif end_line[2] > col('$')
            let lines = getline(getpos("'<")[1], getpos("'>")[1])

        " if start position and end position are both in the middle of line,
        else
            for line in range(start_line[1], end_line[1])
                if iine == start_line[1]
                    let lines += [strpart(getline(line), start_line[2] - 1)]
                elseif line == end_line[1]
                    let lines += [strpart(getline(line), 0, end_line[2])]
                else
                    let lines += [getline(line)]
                endif
            endfor
        endif

        call setpos('.', save_cursor)
    endif

    " save lines to temporary file
    let tmp = tempname()
    call writefile(lines, tmp, 'b')

    " make command
    let fn = shellescape('clipboard@' . tmp)
    let email = shellescape('email=' . email)
    let password = shellescape('pwd=' . password)
    let url = 'https://pastefire.com/set.php'
    let com = printf('curl -k --data-urlencode %s -d %s -d %s %s',
                \ fn, email, password, url)

    " do paste
    echon 'sending...'
    let res = system(com)
    echo 'successful!'

    " delete temporary file
    call delete(tmp)
endfunction

let &cpo = s:save_cpo
