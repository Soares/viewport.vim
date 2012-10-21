if exists('g:viewport_loaded')
	finish
endif
let g:loaded_viewport = 1


" g:viewport_forbidden_files: A list of regexes which forbid certain files.
" g:viewport_forbidden_settings: A list of settings which prevent view creation.
" g:viewport_forbidden_vars: A list of vars which, if existing, signal a mode
"		wherein views should not be created.
" g:viewport_filetypes: Enable/disable viewport by filetype.
" 		0: Disable viewport completely.
" 		1: Enable for all filetypes (default)
" 		[list]: Enable for only the filetypes in this list.
" 		{dict}: Enable unless the filetype is in the dict with a 0 value.
" g:viewport_autoview: Whether to automatically make views.
" g:viewport_automap: Whether to make the default keybindings
call hume#0#def('viewport', {
		\ 'filetypes': 1,
		\ 'forbidden_files': ['^/dev/null$', '^/tmp'],
		\ 'forbidden_settings': ['diff'],
		\ 'forbidden_vars': ['b:viewport_disable'],
		\ 'automap': 0,
		\ })


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


if g:viewport_automap
	" Delete this file's view
	noremap <leader>vx :ViewportClear
	" Delete all file's views
	noremap <leader>vd :ViewportClear!
	" *U*nset a setting globally.
	noremap <leader>vu :ViewportClear! 
	" Unset a setting in *O*nly this view
	noremap <leader>vo :ViewportClear 
endif
