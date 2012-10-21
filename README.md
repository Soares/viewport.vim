# Viewport
## Sweeping views for vim

Vim views are great! When you discover them, your want to use them
everywhere! It's wonderful, until...

* You're diffing a file.
* You open /dev/null by accident.
* You're editing a tmp file.
* You try to exit an empty buffer.

Viewport helps you with that: it turns on views everywhere, except where they're
useless.

So imagine you have views working great, for every file where a view is sane.
Now your views are glorious… until you change your workflow.

Pretend you have `autochdir` set for a few months and then you decide to turn it
off. All of your view files still have it turned on! Now new files will have it
off and old files will have it on and you're never quite sure what you're going
to get. You have three options:

1. Live in constant fear, never knowing when you'll stumble across an old file
   that has crazy settings from a crusty view.
2. Remove all your views. Now your folds and marks are gone! Oh no.
3. Remove 'options' from you 'viewoptions' setting. Now no local mappings or
   options are saved! This is mostly ok, until you remember how often you need
   'tabstop' and 'shiftwidth' set on a per-file basis.

Viewport to the rescue! Viewport lets you clear a certain setting
from all of your view files with the `:ViewportClear` function.

Fair warning:

* `:ViewportClear` only works if you have perl installed.
* Viewport is dependant upon how vim stores view files, which is not a public
  api. It could change at any time, breaking viewport.

Viewport also helps you manage your different numbered views (did you know you
can have *multiple* view files?) and provides nifty statusline integration to
let you know what views are available.

See the help files for more details.
