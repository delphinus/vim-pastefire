command! -range PastefireRange :<line1>,<line2>call pastefire#range()
command! -nargs=1 Pastefire :call pastefire#paste(<args>)
