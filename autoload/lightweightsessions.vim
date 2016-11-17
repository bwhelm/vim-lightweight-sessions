" ====================
" Lightweight Sessions
" ====================

function! lightweightsessions#CreateKeymaps()
	for l:key in keys(g:vim_lws_directories)
		let l:directory = fnamemodify(g:vim_lws_directories[l:key], ":p")
		if filereadable(l:directory)
			let l:realDirectory = fnamemodify(l:directory, ":h")
			execute "nnoremap <silent> " . g:vim_lws_prefix . l:key . " :cd " . fnameescape(l:realDirectory) . "<CR>:edit " . fnameescape(l:directory) . "<CR>"
		else
			execute "nnoremap <silent> " . g:vim_lws_prefix . l:key . " :cd " . fnameescape(l:directory) . "<CR>:Explore " . fnameescape(l:directory) . "<CR>"
		endif
	endfor
endfunction

function! lightweightsessions#OpenSessionList()
	let l:indexString=g:lws_open_string
	let l:index = 0
	let l:indexDictionary = {}
	let l:listOfKeys = sort(keys(g:vim_lws_directories))
	for l:key in l:listOfKeys
		echo l:indexString[l:index] ": (" . l:key . ") " . g:vim_lws_directories[l:key]
		let l:indexDictionary[l:indexString[l:index]] = l:key
		let l:index += 1
	endfor
	let l:answer = input("Enter number/letter (or anything else to quit): ")
	if empty(l:answer)
		return
	endif
	try
		let l:key = l:indexDictionary[l:answer]
		let l:directory = fnamemodify(g:vim_lws_directories[l:key], ":p")
		if !empty(findfile(l:directory))
			let l:realDirectory = fnamemodify(l:directory, ":h")
			execute "edit " . fnameescape(l:directory) . " | cd " . fnameescape(l:realDirectory)
		else
			execute "silent Explore " . fnameescape(l:directory) . " | cd " . fnameescape(l:directory)
		endif
	catch /E716/   " l:answer not a key of l:indexDictionary.
		redraw
		echohl WarningMsg
		echon "Unrecognized input: " . l:answer
		echohl None
	endtry
endfunction
