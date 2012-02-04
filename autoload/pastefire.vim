function! pastefire#range() range
    let lines = getline(a:firstline, a:lastline)
    let str = join(lines, '\n')
    call pastefire#paste(str)
endfunction

function! pastefire#paste(str)
    if len($PF_EMAIL) > 0
        let email = $PF_EMAIL
    elseif len(g:pastefire_email) > 0
        let email = g:pastefire_email
    else
        echoerr 'please specify $PF_EMAIL or g:pastefire_email'
        return
    endif

    if len($PF_PASSWORD) > 0
        let password = $PF_PASSWORD
    elseif len(g:pastefire_password) > 0
        let password = g:pastefire_password
    else
        echoerr 'please specify $PF_PASSWORD or g:pastefire_password'
        return
    endif

    let str = shellescape('clipboard=' . a:str)
    let email = shellescape('email=' . email)
    let password = shellescape('pwd=' . password)
    let url = 'https://pastefire.com/set.php'
    let com = printf('curl --data-urlencode %s -d %s -d %s %s',
                \ str,
                \ email,
                \ password,
                \ url)
    let res = system(com)

    echo 'sent to pastefire!'
endfunction
