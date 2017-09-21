*lightweight-sessions.txt*                               Light-weight sessions

This plugin allows for easy opening of pre-defined files or directories.

CONTENTS                                       *lightweight-sessions-contents*

    1. Using Lightweight Sessions ............... |lightweight-sessions-using|
    2. Configuring Lightweight Sessions ... |lightweight-sessions-configuring|


USING LIGHTWEIGHT-SESSIONS                        *lightweight-sessions-using*

To use lightweight sessions, you must define a dictionary of directory or file
names keyed to a particular set of keys. (See |configuring-lightweight-
sessions|.) 

CONFIGURING LIGHTWEIGHT-SESSIONS            *lightweight-sessions-configuring*

The following variables can be configured (with defaults given):

|g:vim_lws_directories|={}                             *g:vim_lws_directories*
This is the dictionary of directories/files that lightweight sessions will
open. The dictionary key determines the keys to enter following the lightweight
sessions prefix to open the corresponding value. Values are specified as paths
to files or directories; they need not be escaped. For example:

    let g:vim_lws_directories={"d": "~/Documents"}

will allow hitting "<Leader>sd" to view the ~/Documents directory in netrw.

|g:vim_lws_prefix|="<Leader>s"                              *g:vim_lws_prefix*
This specifies the prefix to type before typing the relevant dictionary key.

|g:vim_lws_list|="l"                                          *g:vim_lws_open*
This specifies the key to use with the prefix to present a list of defined
key-file/directory pairs. You can then select one to open.

|g:lws-open-string|="123456789abcdefghijklmnopqrstuvwxyz"  *g:lws-open-string*
This specifies the string of characters to use for activating item in session
list.
