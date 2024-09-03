vim9script

var is_split_active = false
var saved_splitright = &splitright
var origin_win_id = 0
var saved_origin_scrollbind = &scrollbind
# saved_slave_scrollbind is a dict of the form {win_id: saved_splirtight}
var saved_slave_scrollbind = {}
var num_pages = 2

export def ExtendedViewToggle(n: number = 2)
  if !is_split_active
    # Save script-local var for the mappimg
    num_pages = n
    # Save current global splitright option
    saved_splitright = &splitright
    &splitright = true

    # Original window setup
    origin_win_id = win_getid()
    saved_origin_scrollbind = &scrollbind

    # Split windows depending on user input
    var last_win_id = origin_win_id
    if exists('+winfixbuf')
      win_execute(last_win_id, '&winfixbuf = true')
    endif
    for ii in range(1, n - 1)
      win_execute(last_win_id, 'vertical split')
      last_win_id = win_getid(winnr('$'))
      saved_slave_scrollbind[string(last_win_id)] = &scrollbind
      win_execute(last_win_id, 'exe "normal! \<c-f>"')
      win_execute(last_win_id, 'exe "normal! \<c-e>"')
      if exists('+winfixbuf')
        win_execute(last_win_id, '&winfixbuf = true')
      endif
    endfor

    # Set 'scrollbind' for each new window
    win_gotoid(origin_win_id)
    &scrollbind = true
    for win_id in keys(saved_slave_scrollbind)
      win_execute(str2nr(win_id), '&scrollbind = true')
    endfor

    if !hasmapto('<c-f>', 'n')
      nnoremap <expr> <c-f> repeat('<c-f>', num_pages)
    endif
    if !hasmapto('<c-b>', 'n')
      nnoremap <expr> <c-b> repeat('<c-b>', num_pages)
    endif

    # Flag
    is_split_active = true

    # Handling windows close events
    # All the slave windows plus the origin window
    var win_ids = join(add(keys(saved_slave_scrollbind), origin_win_id), ',')
    exe $'autocmd! WinClosed {win_ids} ++once Teardown(true)'
  else
    Teardown(false)
  endif
enddef

def Teardown(from_autocmd: bool)
    # If the origin window is closed, reopen a copy
    if win_getid() == origin_win_id && from_autocmd
      vertical split
      &scrollbind = false
    endif

    # Close slave windows
    for win_id in keys(saved_slave_scrollbind)
      win_execute(str2nr(win_id), 'close!')
    endfor

    # Reset script vars
    win_execute(origin_win_id, $'&scrollbind = {saved_origin_scrollbind}')
    if exists('+winfixbuf')
      win_execute(origin_win_id, '&winfixbuf = false')
    endif

    silent! unmap <c-f>
    silent! unmap <c-b>

    &splitright = saved_splitright
    saved_slave_scrollbind = {}
    origin_win_id = 0
    is_split_active = false
    num_pages = 2
enddef
