# vim-extended-view

Extend the view of your buffer on a number of side-by-side windows!

<p align="center">
<img src="/extended_view.gif" width="75%" height="75%">
</p>

<p align="center" style="font-size:38;">
* Vim-extended-view *
</p>

This simple plugin provides only one command `:ExtendedViewToggle <number>`,
where `<number>` is the number of the side-by-side windows where the current
buffer spans over. If `<number>` is not provided, then the buffer view is
extended on 2 windows by default.

To quit the extended view mode, run `:ExtendedViewToggle` again or just close
any window containing the extended view.

If you don't have any mapping for `<c-f>` and `<c-b>`, then they are set to
scroll `<number>` pages per time during the extended view. Handy!

Enjoy!
