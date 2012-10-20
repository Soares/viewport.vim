function! viewport#file()
	let l:path = substitute(expand('%:p'), '^'.expand('$HOME'), '~', '')
	let l:path = substitute(l:path, '/', '*', 'g')
	return glob(expand(&viewdir.'/'.l:path.'='), 0, 1)
endfunction


function! viewport#all()
	return &viewdir.'/*='
endfunction


function! viewport#clear(all, ...)
	if empty(&viewdir)
		return
	endif
	let l:path = a:all ? viewport#all() : viewport#file()
	if a:0 > 0
		call viewport#unset(l:path, a:000)
	else
		exe ':silent !rm -rf '.l:path
		redraw!
	endif
endfunction


function! viewport#unset(path, settings)
	let l:regex = '^setl(ocal)?\s+(no?)('.join(a:settings, '|').')\b'
	exe ':silent !perl -i -nle "print unless /'.l:regex.'/" '.a:path
	redraw!
endfunction


" Whether or not a view should be made for this file.
" @return {boolean}
" 	* False for buftype 'nofile'
" 	* False if any of g:viewport_forbidden_settings is set
" 	* False if any of g:viewport_forbidden_vars is on
" 	* False if the filetype is forbidden by g:viewport_filetypes
" 	* False if the file is empty
" 	* False if the file is forbidden by g:viewport_forbidden_files
" 	* True otherwise
function! viewport#shouldmake()
	if &buftype =~ 'nofile'
		return 0
	endif
	for l:setting in g:viewport_forbidden_settings
		exe 'if &'.l:setting.' | return 0 | endif'
	endfor
	for l:var in g:viewport_forbidden_vars
		exe 'if exists("'.l:var.'") && '.l:var.' | return 0 | endif'
	endfor
	if !hume#0#check(g:viewport_filetypes)
		return 0
	endif
	let l:file = glob(expand('%:p'))
	if empty(l:file)
		" File does not exist on disk
		return 0
	endif
	for l:regex in g:viewport_forbidden_files
		if l:file =~# l:regex
			return 0
		endif
	endfor
	return 1
endfunction
