function! viewport#status#flag()
	let l:flag = viewport#status#alert()
	if empty(l:flag)
		let l:flag = viewport#status#info()
	endif
	return l:flag
endfunction


function! viewport#status#alert()
	let l:views = viewport#views()
	if empty(l:views)
		return '[no view]'
	endif
	return ''
endfunction


function! viewport#status#info()
	let l:views = viewport#views()
	if l:views == '0'
		return '[view]'
	elseif l:views =~# '0'
		return '[view *'.substitute(l:views[1:],'0','','').']'
	elseif !empty(l:views)
		return '[view '.l:views.']'
	endif
	return ''
endfunction
