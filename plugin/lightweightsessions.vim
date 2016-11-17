" ================
" Default settings
" ================
"  g:vim_lws_directories contains a dictionary of
"  directories/files to be opened. Note that directory paths should not be
"  escaped.
if !exists('g:vim_lws_directories')
	let g:vim_lws_directories = {}
endif

" Prefix to use for opening sessions
if !exists('g:vim_lws_prefix')
	let g:vim_lws_prefix = "<Leader>s"
endif

" Mapping to use (with prefix) for opening list of defined sessions
if !exists('g:vim_lws_list')
	let g:vim_lws_list = "l"
endif

" Ordered string of characters to use for activating item in session list
" (via OpenSessionList).
if !exists('g:lws_open_string')
	let g:lws_open_string = "123456789abcdefghijklmnopqrstuvwxyz"
endif

" ==========
" Initialize
" ==========
" Define command and mapping for session list
command! OpenSessionList call lightweightsessions#OpenSessionList()
execute "nnoremap " . g:vim_lws_prefix . g:vim_lws_list . " :OpenSessionList<CR>"
" Create keymappings for all defined files/directories
call lightweightsessions#CreateKeymaps()
