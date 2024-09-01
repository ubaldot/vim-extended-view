# vim-extended-view

Extend the view of your buffer on a number of side-by-side windows!

<p align="center">
<img src="/ExtendedView.mp4" width="75%" height="75%">
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

Enjoy!
