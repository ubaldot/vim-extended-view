vim9script noclear

# Extend your buffer content to another window!
# Maintainer:	Ubaldo Tiberi
# License: Vim-License

# The plugin changes two options:
#   1. splitright because we want to extend towards right
#   2. scrollbind because we want the splits to move all together

if !has('vim9script') ||  v:version < 900
    # Needs Vim version 9.0 and above
    echo "You need at least Vim 9.0"
    finish
endif

if exists('g:vim_extended_view_loaded')
    finish
endif
g:vim_extended_view_loaded = true


import autoload "../lib/funcs.vim"

command! -nargs=? ExtendedViewToggle funcs.ExtendedViewToggle(<args>)
