# Viewport
## Sweeping views for vim

Vim views are great! When you discover them, your first reaction is to use them
everywhere. But have you ever tried that? It's fine, until...

* You're diffing a file.
* You open /dev/null by accident.
* You're editing a tmp file.
* You try to exit an empty buffer.

Viewport helps you with that: it helps you turn on views everywhere, except for
when they're useless.

So imagine you have views working great, for every file where a view is sane to
have. Now your views are glorious… until you change your workflow.

Imagine you have `autochdir` set for a few months and then you decide to turn it
off. All of your view files still have it turned on! Now new files will have it
off and old files will have it on and you're never quite sure what you're going
to get. You have three options:

1. Live in constant fear, never knowing when you'll stumble across an old view
   that has crazy settings
2. Remove all your views. Now your folds are gone! Oh no.
3. Remove 'options' from you 'viewoptions' setting. Now no local mappings or
   options are saved! Given that 'tabstop' and 'shiftwidth' are different in
   almost every file this can be seriously annoying.

Viewport to the rescue! Viewport lets you clear a certain setting
from all of your view files with the `:ViewportClear` function.

Fair warning: Viewport has a perl dependency and depends upon some unstable vim
features. It may break if vim updates.

See the help files for more details.
