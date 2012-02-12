" Vim global plugin for Pastefire (http://pastefire.com/)
" Last Change: 2012 Feb 12
" Maintainer: delphinus <delphinus@remora.cx>
" License: This file is placed in th public domain.

if exists('g:loaded_pastefire')
    finish
endif
let g:loaded_pastefire =1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* -range Pastefire
            \ call pastefire#run(<q-args>, <line1>, <line2>)

nnoremap <unique> <Plug>(pastefire) :<C-u>Pastefire n<CR>
vnoremap <unique> <Plug>(pastefire) :<C-u>Pastefire v<CR>

if !hasmapto('<Plug>(pastefire)')
    map <unique> <Leader>pf <Plug>(pastefire)
endif

let &cpo = s:save_cpo
unlet s:save_cpo
