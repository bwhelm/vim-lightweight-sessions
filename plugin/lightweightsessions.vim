" ================
" Default settings
" ================
"  g:vim_lws_directories contains a dictionary of
"  directories/files to be opened. Note that directory paths should not be
"  escaped.
let g:vim_lws_directories = get(g:, 'vim_lws_directories', {})

" Prefix to use for opening sessions
let g:vim_lws_prefix = get(g:, 'vim_lws_prefix', '<Leader>s')

" Mapping to use (with prefix) for opening list of defined sessions
let g:vim_lws_list = get(g:, 'vim_lws_list', 'l')

" Ordered string of characters to use for activating item in session list
" (via OpenSessionList).
let g:lws_open_string = get(g:, 'lws_open_string',
            \ '123456789abcdefghijklmnopqrstuvwxyz')

" ==========
" Initialize
" ==========
" Define command and mapping for session list
execute 'nnoremap' g:vim_lws_prefix . g:vim_lws_list
            \ ':call lightweightsessions#OpenSessionList()<CR>'
" Create keymappings for all defined files/directories
call lightweightsessions#CreateKeymaps()
