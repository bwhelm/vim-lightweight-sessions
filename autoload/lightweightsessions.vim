scriptencoding utf-8
" vim: set fdm=marker:
" ============================================================================
" Lightweight Sessions
" ============================================================================

function! lightweightsessions#CreateKeymaps() abort  "{{{
    for l:key in keys(g:lws_directories)
        let l:fileOrDir = fnamemodify(g:lws_directories[l:key], ':p')
        let l:directory = fnamemodify(l:fileOrDir, ':h')
        if l:directory =~ "^scp:"
            let l:cdDir = l:directory
        else
            let l:cdDir = finddir('.git', l:directory . ';')
            if l:cdDir == ''
                let l:cdDir = fnamemodify(l:directory, ":p:h")
            else
                let l:cdDir = fnamemodify(l:cdDir, ":p:h:h")
            endif
        endif
        if filereadable(l:fileOrDir)  " Accessing local file. Find dir and cd
            " if l:fileOrDir =~? '^\[dav\|fetch\|ftp\|http\|rcp\|rsync\|scp\|sftp\]://'
            "     " Accessing file on remote server; simply open it.
            "     execute 'nnoremap <silent>' g:lws_prefix . l:key 'edit' fnameescape(l:fileOrDir) . '<CR>'
            " else  " Accessing local file. cd to parent directory and open the file.
            execute 'nnoremap <silent>' g:lws_prefix . l:key ':lcd' fnameescape(cdDir) '\| edit' fnameescape(l:fileOrDir) . '<CR>'
            " endif
        " elseif l:fileOrDir =~? '^\[dav\|fetch\|ftp\|http\|rcp\|rsync\|scp\|sftp\]://'
        "     " Here we're accessing a remote server and don't want to change
        "     " the directory.
        "     execute 'nnoremap <silent>' g:lws_prefix . l:key ':' . g:lws_fileCommand . ' ' . fnameescape(l:fileOrDir) . '<CR>'
        else  " Accessing local directory: change directory first.
            execute 'nnoremap <silent>' g:lws_prefix . l:key ':lcd' fnameescape(l:cdDir) '\|' g:lws_fileCommand fnameescape(l:fileOrDir) . '<CR>'
        endif
    endfor
endfunction
"}}}
function! lightweightsessions#OpenSessionList() abort  "{{{
    let l:indexString=g:lws_open_string
    let l:index = 0
    let l:indexDictionary = {}
    let l:listOfKeys = sort(keys(g:lws_directories))
    for l:key in l:listOfKeys
        echo l:indexString[l:index] . ': (' . l:key . ')' g:lws_directories[l:key]
        let l:indexDictionary[l:indexString[l:index]] = l:key
        let l:index += 1
    endfor
    echo 'Enter number/letter (or anything else to quit): '
    let l:answer = nr2char(getchar())
    redraw
    if has_key(l:indexDictionary, l:answer)
        let l:key = l:indexDictionary[l:answer]
        let l:fileOrDir = fnamemodify(g:lws_directories[l:key], ':p')
        if !empty(findfile(l:fileOrDir))
            let l:directory = fnamemodify(l:fileOrDir, ':h')
            execute 'cd' fnameescape(l:directory) '| edit' fnameescape(l:fileOrDir)
        else
            execute 'cd' fnameescape(l:fileOrDir) '|' g:lws_fileCommand fnameescape(l:fileOrDir)
        endif
    else   " l:answer not a key of l:indexDictionary.
        echohl WarningMsg
        echon 'Aborted.'
        echohl None
    endif
endfunction
"}}}
function! s:getFileSuffix(delete) abort  " {{{
    if a:delete == "Delete"
        echohl WarningMsg
        let l:warning = ' (will be deleted)'
    else
        let l:warning = ''
    endif
    if g:lws_last_session == ''
        let l:fileSuffix = input("Session name" . l:warning . ": ")
    else
        let l:fileSuffix = input("Session name" . l:warning . " [" . g:lws_last_session . "]: ")
        if l:fileSuffix == ''
            let l:fileSuffix = g:lws_last_session
        endif
    endif
    echohl None
    return l:fileSuffix
endfunction
"}}}
function! lightweightsessions#createSession(...) abort  "{{{
    " This saves a session file to ~/.vim/mysession-X, where X is the count.
    if v:count == 0  " No count given: ask for name
        if a:0 == 1
            let l:fileSuffix = a:1
        else
            let l:fileSuffix = <SID>getFileSuffix('')
            if l:fileSuffix == ''
                redraw | echo 'Canceled.'
                return
            endif
        endif
    else             " Count given, append that to filename
        let l:fileSuffix = v:count
    endif
    let l:file = g:myVimDir . '/mysession-' . l:fileSuffix . '.vim'
    if filereadable(l:file)
        echohl WarningMsg
        redraw | echo 'Sessions file "' . l:fileSuffix . '" exists; overwrite [y/N]?'
        echohl None
        if nr2char(getchar()) !~? 'y'
            redraw | echo 'Canceled.'
            return
        endif
    endif
    execute 'mksession!' l:file
    let l:contents = readfile(l:file)
    " Remove unwanted entries in session.
    let l:contents = filter(l:contents, 'v:val !~# "^setlocal"')
    call insert(l:contents, '%bwipeout', 1)
    call writefile(l:contents, l:file)
    redraw | echo 'Session' l:fileSuffix 'saved.'
    let g:lws_last_session = l:fileSuffix
endfunction
"}}}
function! lightweightsessions#loadSession(count, delete) abort  "{{{
    " This loads a session file from ~/.vim/mysession, and then optionally
    " deletes it.
    if a:count =~ '[1-9]'  " A count was given; use that
        let l:fileSuffix = a:count
    elseif a:count == ''
        let l:fileSuffix = <SID>getFileSuffix(a:delete)
        if l:fileSuffix == ''
            redraw | echo 'Canceled.'
            return
        endif
    else
        let l:fileSuffix = a:count
    endif
    let l:file = g:myVimDir . '/mysession-' . l:fileSuffix . '.vim'
    if !filereadable(l:file)
        echohl Error
        redraw | echo 'No session file exists at' fnamemodify(l:file, ':~') . '.'
        echohl None
        return
    endif
    execute 'silent source' l:file
    if a:delete ==# 'Delete'
        if delete(l:file)
            echohl Error
            redraw | echo 'Session loaded, but could not delete session file.'
            echohl None
        else
            redraw | echo 'Session' l:fileSuffix 'loaded; session file deleted.'
        endif
    else
        redraw | echo 'Session' l:fileSuffix 'loaded.'
    endif
    let g:lws_last_session = l:fileSuffix
endfunction
"}}}
function! lightweightsessions#chooseSessions(delete) abort  "{{{
    " Display list of session files, ask for one to be picked.
    let fileList = glob(g:myVimDir . '/mysession-*', 0, 1)
    if !len(fileList)
        echohl Error
        redraw | echo 'No session files.'
        echohl None
        return
    endif
    for i in range(len(fileList))
        echo i + 1 . '.' fnamemodify(fileList[i], ':t')[10:-5]
    endfor
    if a:delete == "Delete"
        echohl WarningMsg
        echo 'Enter number of session to load and delete: '
        echohl None
    else
        echo 'Enter number of session: '
    endif
    let l:number = nr2char(getchar())
    redraw
    if l:number =~ '\d' && l:number > 0 && l:number <= len(fileList)
        let l:fileSuffix = fnamemodify(fileList[l:number - 1], ':t')[10:-5]
        call lightweightsessions#loadSession(l:fileSuffix, a:delete)
    else
        redraw | echo "Aborting...."
    endif
endfunction
"}}}
