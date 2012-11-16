" Breaks a string into a list of characters.
" @param {string} String the string.
" @return {list} A list of the characters in the string.
function! s:strlist(string)
	let l:list = []
	for l:i in range(0, len(a:string)-1)
		call add(l:list, a:string[l:i])
	endfor
	return l:list
endfunction


" Checks whether a setting allows a value.
" Designed for settings that can be either global, whitelisted, or blacklisted.
" @param {number|list|dict} setting The setting to check
" @param {string?} value The value to check. Default &ft.
" @return Depends upon the setting:
"		If a number or string, the setting is returned and the value ignored
"		If a list, returns whether or not the value is in the list
"		If a dict, returns setting[value] (defaults to 1)
function! s:check(setting, ...)
	let l:value = a:0 > 0 ? a:1 : &ft
	if type(a:setting) == type([])
		return index(a:setting, l:value) >= 0
	elseif type(a:setting) == type({})
		return get(a:setting, l:value, 1)
	endif
	return a:setting
endfunction


" Finds the views for a file.
" @param {list} numbers The numbers of view files to find, each 0-9.
"		If empty, search for all numbers.
"@param {string?} path The path to search for, defaults to this file's base
"		viewfile. Globs allowed.
" @return {list} The view files
function! viewport#files(numbers, ...)
	if a:0 == 0
		let l:path = substitute(expand('%:p'), '^'.expand('$HOME'), '~', '')
		let l:path = substitute(l:path, '/', '*', 'g')
	else
		let l:path = a:1
	endif
	if empty(a:numbers)
		return glob(&viewdir.'/'.l:path.'=?', 0, 1)
	endif
	let l:files = []
	for l:num in a:numbers
		if l:num == 0
			let l:files += glob(&viewdir.'/'.l:path.'=', 0, 1)
		else
			let l:files += glob(&viewdir.'/'.l:path.'='.l:num.'.vim', 0, 1)
		endif
	endfor
	return l:files
endfunction


" Removes settings from a path of vim files. If no settings are given, remove
" the whole file.
" @param {list} files The list of files to remove the settings from.
" @param {list} settings A list of settings to remove. Full name required.
function! viewport#unset(files, settings)
	if empty(a:files)
		return
	endif
	let l:files = join(a:files, ' ')
	if empty(a:settings)
		exe ':silent !rm -rf '.l:files
	else
		let l:regex = '^setl(ocal)?\s+(no)?('.join(a:settings, '|').')\b'
		exe ':silent !perl -i -nle "print unless /'.l:regex.'/" '.l:files
	endif
	redraw!
endfunction


" Clears view settings.
" @param {boolean} all Whether to affect all views or this files' views.
" @param {string?} numbers The numbers of view files to affect, 0-9.
" @param {string...} settings to wipe. If not given, views will be removed.
function! viewport#clear(all, ...)
	if empty(&viewdir)
		return
	endif
	if a:0 > 0 && a:1 =~ '\v\d+'
		let l:nums = s:strlist(a:1)
		let l:settings = a:000[1:]
	else
		let l:nums = [0]
		let l:settings = filter(a:000[:], '!empty(v:val)')
	endif
	let l:files = a:all ? viewport#files(l:nums, '*') : viewport#files(l:nums)
	call viewport#unset(l:files, l:settings)
endfunction


" Figure out which numbered view files exist for this file
" (0 is used for the default file.)
" @return {string} The numbers of view files which exist.
function! viewport#views()
	let l:views = ''
	let l:files = sort(viewport#files([]))
	for l:file in l:files
		if l:file =~# '\v\=$'
			let l:views .= '0'
		else
			let l:views .= substitute(l:file, '\v^.*\=(\d)\.vim', '\1', '')
		endif
	endfor
	return l:views
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
	if !s:check(g:viewport_filetypes)
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
