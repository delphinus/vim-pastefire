function! pastefire#run(str, line1, line2)
    if exists('$PF_EMAIL') && len($PF_EMAIL) > 0
        let email = $PF_EMAIL
    elseif exists('g:pastefire_email') && len(g:pastefire_email) > 0
        let email = g:pastefire_email
    else
        echomsg 'please specify $PF_EMAIL or g:pastefire_email'
        return
    endif

    if exists('$PF_PASSWORD') && len($PF_PASSWORD) > 0
        let password = $PF_PASSWORD
    elseif exists('g:pastefire_password') && len(g:pastefire_password) > 0
        let password = g:pastefire_password
    else
        echomsg 'please specify $PF_PASSWORD or g:pastefire_password'
        return
    endif

    echo a:str
    let ary = split(a:str)
    echo ary
    if get(ary, 0) ==# 'n'
        let lines = [get(ary, 1)]
    elseif get(ary, 0) ==# 'v'
        let lines = getline(getpos("'<")[1], getpos("'>")[1])
    elseif a:line1 > 0 && a:line2 > 0
        let lines = getline(a:firstline, a:lastline)
    else
        let lines = [a:str]
    endif

    let lines[0] = 'clipboard=' . lines[0]
    let tmp = tempname()
    call writefile(lines, tmp, 'b')

    let fn = shellescape('@' . tmp)
    let email = shellescape('email=' . email)
    let password = shellescape('pwd=' . password)
    let url = 'https://pastefire.com/set.php'
    let com = printf('curl -k --data-binary %s -d %s -d %s %s',
                \ fn, email, password, url)
    echo 'sending...'
    let res = system(com)
    echo 'successful!'
endfunction
