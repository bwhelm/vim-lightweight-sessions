" ====================
" Lightweight Sessions
" ====================

function! lightweightsessions#CreateKeymaps()
	for l:key in keys(g:vim_lws_directories)
		let l:fileOrDir = fnamemodify(g:vim_lws_directories[l:key], ':p')
		if filereadable(l:fileOrDir)  " Accessing local file. Find dir and cd
			if l:fileOrDir =~? '^\[dav\|fetch\|ftp\|http\|rcp\|rsync\|scp\|sftp\]://'
				" Accessing file on remote server; simply open it.
				execute 'nnoremap <silent> ' . g:vim_lws_prefix . l:key . ' edit ' . fnameescape(l:fileOrDir) . '<CR>'
			else  " Accessing local file. Open it and cd to parent directory
				let l:directory = fnamemodify(l:fileOrDir, ':h')
				execute 'nnoremap <silent> ' . g:vim_lws_prefix . l:key . ' :cd ' . fnameescape(l:directory) . '<CR>:edit ' . fnameescape(l:fileOrDir) . '<CR>'
			endif
		elseif l:fileOrDir =~? '^\[dav\|fetch\|ftp\|http\|rcp\|rsync\|scp\|sftp\]://'
			" Here we're accessing a remote server and don't want to change
			" the directory.
			execute 'nnoremap <silent> ' . g:vim_lws_prefix . l:key . ' :Explore ' . fnameescape(l:fileOrDir) . '<CR>'
		else  " Accessing local directory: change directory first.
			execute 'nnoremap <silent> ' . g:vim_lws_prefix . l:key . ' :cd ' . fnameescape(l:fileOrDir) . '<CR>:Explore ' . fnameescape(l:fileOrDir) . '<CR>'
		endif
	endfor
endfunction

function! lightweightsessions#OpenSessionList()
	let l:indexString=g:lws_open_string
	let l:index = 0
	let l:indexDictionary = {}
	let l:listOfKeys = sort(keys(g:vim_lws_directories))
	for l:key in l:listOfKeys
		echo l:indexString[l:index] . ': (' . l:key . ') ' . g:vim_lws_directories[l:key]
		let l:indexDictionary[l:indexString[l:index]] = l:key
		let l:index += 1
	endfor
	let l:answer = input('Enter number/letter (or anything else to quit): ')
	if empty(l:answer)
		return
	endif
	try
		let l:key = l:indexDictionary[l:answer]
		let l:fileOrDir = fnamemodify(g:vim_lws_directories[l:key], ':p')
		if !empty(findfile(l:fileOrDir))
			let l:directory = fnamemodify(l:fileOrDir, ':h')
			execute 'edit ' . fnameescape(l:fileOrDir) . ' | cd ' . fnameescape(l:directory)
		else
			execute 'silent Explore ' . fnameescape(l:fileOrDir) . ' | cd ' . fnameescape(l:fileOrDir)
		endif
	catch /E716/   " l:answer not a key of l:indexDictionary.
		redraw
		echohl WarningMsg
		echon 'Unrecognized input: ' . l:answer
		echohl None
	endtry
endfunction
