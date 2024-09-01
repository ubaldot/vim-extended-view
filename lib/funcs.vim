vim9script

var is_split_active = false
var saved_splitright = &splitright
var original_win_id = 0
var saved_original_scrollbind = &scrollbind
# saved_slave_scrollbind is a dict of the form {win_id: saved_splirtight}
var saved_slave_scrollbind = {}

export def ExtendedViewToggle(n: number = 2)
  if !is_split_active
    # Save current global splitright option
    saved_splitright = &splitright
    &splitright = true

    # Original window setup
    original_win_id = win_getid()

    # Split windows depending on user input
    var last_win_id = original_win_id
    for ii in range(1, n - 1)
      win_execute(last_win_id, 'vertical split')
      last_win_id = win_getid(winnr('$'))
      saved_slave_scrollbind[string(last_win_id)] = &scrollbind
      win_execute(last_win_id, 'exe "normal! \<c-f>"')
      win_execute(last_win_id, 'exe "normal! \<c-e>"')
    endfor

    # Set 'scrollbind' for each new window
    win_gotoid(original_win_id)
    &scrollbind = true
    for win_id in keys(saved_slave_scrollbind)
      win_execute(str2nr(win_id), '&scrollbind = true')
    endfor

    # Flag
    is_split_active = true

    # Handling windows close events
    # All the slave windows plus the original window
    var win_ids = join(add(keys(saved_slave_scrollbind), original_win_id), ',')
    exe $'autocmd! WinClosed {win_ids} ++once Teardown()'
  else
    Teardown()
  endif
enddef

def Teardown()
    # If the original window is closed, reopen a copy
    if win_getid() == original_win_id
      vertical split
      &scrollbind = false
    endif

    # Close slave windows
    for win_id in keys(saved_slave_scrollbind)
      win_execute(str2nr(win_id), 'close!')
    endfor

    # Reset script vars
    win_execute(original_win_id, $'&scrollbind = {saved_original_scrollbind}')
    &splitright = saved_splitright
    saved_slave_scrollbind = {}
    original_win_id = 0
    is_split_active = false
enddef
