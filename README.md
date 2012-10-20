# Viewport
## Sweeping views for vim

Vim view management (with mkview and loadview) is great, unless you change your
workflow. If you change a global setting, it's incredibly annoying to have every
file that's ever had a view saved trumping your global setting change.

Viewport allows you to clear out your views, either globally or for specific
files. In the future it may allow you to clear just one setting globally.

`:ViewportClear` clears the view for the current buffer.
`:ViewportClear!` clears all views.

Viewport is still a bit hackish and dependant upon your vim version, so watch
out. Your mileage may vary.
