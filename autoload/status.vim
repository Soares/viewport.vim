function! viewport#status#flag()
	let l:flag = viewport#status#message()
	if empty(l:flag)
		let l:flag = viewport#status#info()
	endif
	return l:flag
endfunction


function! viewport#status#info()
	let l:views = viewport#views()
	if l:views == '0'
		return '[view]'
	elseif l:views =~# '\v^0'
		return '[view *'.l:views[1:].']'
	else
		return '[view '.l:views.']'
	endif
	return ''
endif


function! viewport#status#message()
	let l:views = viewport#views()
	if empty(l:views)
		return '[no view]'
	endif
	return ''
endfunction
