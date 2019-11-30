scriptencoding utf-8
" vim: set fdm=marker:
" ============================================================================
" Lightweight Sessions
" ============================================================================

function! lightweightsessions#CreateKeymaps() abort  "{{{
    for l:key in keys(g:vim_lws_directories)
        let l:fileOrDir = fnamemodify(g:vim_lws_directories[l:key], ':p')
        if filereadable(l:fileOrDir)  " Accessing local file. Find dir and cd
            if l:fileOrDir =~? '^\[dav\|fetch\|ftp\|http\|rcp\|rsync\|scp\|sftp\]://'
                " Accessing file on remote server; simply open it.
                execute 'nnoremap <silent>' g:vim_lws_prefix . l:key 'edit' fnameescape(l:fileOrDir) . '<CR>'
            else  " Accessing local file. cd to parent directory and open the file.
                let l:directory = fnamemodify(l:fileOrDir, ':h')
                execute 'nnoremap <silent>' g:vim_lws_prefix . l:key ':cd' fnameescape(l:directory) . '\| edit' fnameescape(l:fileOrDir) . '<CR>'
            endif
        elseif l:fileOrDir =~? '^\[dav\|fetch\|ftp\|http\|rcp\|rsync\|scp\|sftp\]://'
            " Here we're accessing a remote server and don't want to change
            " the directory.
            execute 'nnoremap <silent>' g:vim_lws_prefix . l:key ':Explore' fnameescape(l:fileOrDir) . '<CR>'
        else  " Accessing local directory: change directory first.
            execute 'nnoremap <silent>' g:vim_lws_prefix . l:key ':cd' fnameescape(l:fileOrDir) . '\| Explore' fnameescape(l:fileOrDir) . '<CR>'
        endif
    endfor
endfunction
"}}}
function! lightweightsessions#OpenSessionList() abort  "{{{
    let l:indexString=g:lws_open_string
    let l:index = 0
    let l:indexDictionary = {}
    let l:listOfKeys = sort(keys(g:vim_lws_directories))
    for l:key in l:listOfKeys
        echo l:indexString[l:index] . ': (' . l:key . ')' g:vim_lws_directories[l:key]
        let l:indexDictionary[l:indexString[l:index]] = l:key
        let l:index += 1
    endfor
    echo 'Enter number/letter (or anything else to quit): '
    let l:answer = nr2char(getchar())
    redraw
    if has_key(l:indexDictionary, l:answer)
        let l:key = l:indexDictionary[l:answer]
        let l:fileOrDir = fnamemodify(g:vim_lws_directories[l:key], ':p')
        if !empty(findfile(l:fileOrDir))
            let l:directory = fnamemodify(l:fileOrDir, ':h')
            execute 'cd' fnameescape(l:directory) '| edit' fnameescape(l:fileOrDir)
        else
            execute 'cd' fnameescape(l:fileOrDir) '| Explore' fnameescape(l:fileOrDir)
        endif
    else   " l:answer not a key of l:indexDictionary.
        echohl WarningMsg
        echon 'Aborted.'
        echohl None
    endif
endfunction
"}}}
