if exists('g:viewport_loaded')
	finish
endif
let g:loaded_viewport = 1


" Enable/disable viewport by filetype.
" 		0: Disable viewport completely.
" 		1: Enable for all filetypes (default)
" 		[list]: Enable for only the filetypes in this list.
" 		{dict}: Enable unless the filetype is in the dict with a 0 value.
if !exists('g:viewport_filetypes')
	let g:viewport_filetypes = 1
endif

" A list of regexes which forbid certain files.
if !exists('g:viewport_forbidden_files')
	let g:viewport_forbidden_files = ['^/dev/null$', '^/tmp']
endif

" A list of settings which prevent view creation.
if !exists('g:viewport_forbidden_settings')
	let g:viewport_forbidden_settings = ['diff']
endif

" A list of vars which, if existing, signal a mode
"		wherein views should not be created.
if !exists('g:viewport_forbidden_vars')
	let g:viewport_forbidden_vars = ['b:viewport_disable']
endif

" Whether to automatically make views.
if !exists('g:viewport_autoview')
	let g:viewport_autoview = 1
endif

" Whether to make the default keybindings
if !exists('g:viewport_automap')
	let g:viewport_automap = 0
endif


" The main Viewport command
command! -bang -nargs=* ViewportClear
		\ call viewport#clear('!' == '<bang>', <f-args>)


if type(g:viewport_filetypes) != type(0) || g:viewport_filetypes
	augroup viewport
		autocmd!
		" Autosave & Load Views.
		autocmd BufWritePost,BufLeave,WinLeave ?* if viewport#shouldmake()
				\| 	mkview
				\| endif
		autocmd BufWinEnter ?* if viewport#shouldmake()
				\| 	silent loadview
				\| endif
	augroup end
endif


if !empty(g:viewport_automap)
	if type(g:viewport_automap) == type(1)
		let g:viewport_automap = 'v'
	endif

	exe 'noremap <leader>' . g:viewport_automap . 'd :ViewportClear!'
	exe 'noremap <leader>' . g:viewport_automap . 'e :ViewportClear '
	exe 'noremap <leader>' . g:viewport_automap . 'u :ViewportClear! '
	exe 'noremap <leader>' . g:viewport_automap . 'x :ViewportClear'
endif
