function! pastefire#range() range
    let lines = getline(a:firstline, a:lastline)
    let str = join(lines, "\n")
    call pastefire#paste(str)
endfunction

function! pastefire#paste(str)
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

    let str = substitute(shellescape('clipboard=' . a:str), '\\\ze\n', '', 'g')
    let email = shellescape('email=' . email)
    let password = shellescape('pwd=' . password)
    let url = 'https://pastefire.com/set.php'
    let com = printf('curl --data-urlencode %s -d %s -d %s %s',
                \ str, email, password, url)
    echo 'sending...'
    let res = system(com)
    echo 'successful!'
endfunction
