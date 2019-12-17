" ----------------------------------------------------------------------------
" Default settings
" ----------------------------------------------------------------------------
"  g:lws_directories contains a dictionary of
"  directories/files to be opened. Note that directory paths should not be
"  escaped.
let g:lws_directories = get(g:, 'lws_directories', {})

" Prefix to use for opening sessions
let g:lws_prefix = get(g:, 'lws_prefix', '<Leader>s')

" Mapping to use (with prefix) for opening list of defined sessions
let g:lws_list = get(g:, 'lws_list', 'l')

" Ordered string of characters to use for activating item in session list
" (via OpenSessionList).
let g:lws_open_string = get(g:, 'lws_open_string',
            \ '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')

" ----------------------------------------------------------------------------
" Initialize
" ----------------------------------------------------------------------------
" Define command and mapping for session list
execute 'nnoremap' g:lws_prefix . g:lws_list
            \ ':call lightweightsessions#OpenSessionList()<CR>'
" Create keymappings for all defined files/directories
call lightweightsessions#CreateKeymaps()


execute 'nnoremap' g:lws_prefix . 's :<C-u>call lightweightsessions#createSession()<CR>'
execute 'nnoremap' g:lws_prefix . 'L :<C-u>call lightweightsessions#loadSession(v:count, "Delete")<CR>'
execute 'nnoremap' g:lws_prefix . 'l :<C-u>call lightweightsessions#loadSession(v:count, "")<CR>'
execute 'nnoremap' g:lws_prefix . 'C :<C-u>call lightweightsessions#chooseSessions("Delete")<CR>'
execute 'nnoremap' g:lws_prefix . 'c :<C-u>call lightweightsessions#chooseSessions("")<CR>'

let g:lws_last_session = ''
