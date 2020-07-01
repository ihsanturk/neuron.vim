func! util#get_platform() abort
	if has('win32') || has('win64')
		return 'win'
	elseif has('mac') || has('macvim')
		return 'macos'
	else
		return 'linux'
	endif
endf

func! util#is_current_buf_zettel()
	" TODO: Use filetypes instead with au commands and ftdetect/ folder.
	if expand('%:p') =~ g:zkdir.'.*'.g:zextension
		return v:true
	else
		return v:false
	end
endf

func! util#insert(thing)
	put =a:thing
endf

func! util#get_list_pair_zettelid_zetteltitle()
	let l:final = []
	for i in keys(g:cache_zettels)
		call add(l:final, util#format_zettelid(i).':'.g:cache_zettels[i]['zettelTitle'])
	endfor
	return l:final
endf

func! util#is_zettelid_valid(zettelid)
	if empty(a:zettelid)
		return 0
	end
	if !exists('g:cache_zettels') || empty('g:cache_zettels')
		call neuron#refresh_cache()
	endif
	if index(keys(g:cache_zettels), util#deform_zettelid(a:zettelid)) >= 0
		return 1
	else
		return 0
	end
endf

func! util#filter_zettels_in_line(line, ...)
	let l:found = []
	let l:n = get(a:, 1, -1)
	for i in keys(g:cache_zettels)
		let l:matched = util#deform_zettelid(matchstr(a:line, util#format_zettelid(i)))
		if !empty(l:matched)
			call add(l:found, l:matched)
		end
	endfor
	if l:n < 0 " index given as optional arg in
		return l:found " list
	else
		return l:found[l:n] " string
	end
endf

func! util#deform_zettelid(zettelid)
	if a:zettelid =~ "<.*>"
		return substitute(a:zettelid, '<\([0-9a-zA-Z_-]\+\)\(?cf\)\?>', '\1', 'g')
	else
		return a:zettelid
	end
endf

func! util#format_zettelid(zettelid)
	if a:zettelid =~ "<.*>"
		return a:zettelid
	else
		return '<'.a:zettelid.'>'
	end
endf

" (line, [nth])
func! util#get_formatted_zettelid(line, ...)
	let l:n = get(a:, 1, 0)
	let l:found = util#filter_zettels_in_line(a:line)
	if len(l:found) > l:n
		return util#format_zettelid(l:found[l:n])
	else
		throw 'Could not find any zettelids in this line: "'.a:line.'"'
	end
endf

func! util#insert_shrink_fzf(line)
	call util#insert(util#get_formatted_zettelid(a:line, 0))
endf

func! util#edit_shrink_fzf(line)
	call neuron#edit_zettel(util#filter_zettels_in_line(a:line, 0))
endf

func! util#get_file_modified_last(dir, extension)
	return system('ls -t '.a:dir.'*'.a:extension.' | head -1')
endf

func! util#remove_orphans(title)
	let l:count = 0
	let l:targetdir = '/tmp/orphan-zettels'
	call mkdir(l:targetdir, 'p')
	for i in keys(g:cache_zettels)
		if g:cache_zettels[i]['zettelTitle'] == a:title
			call system("mv ".g:cache_zettels[i]['path']." ".l:targetdir)
			let l:count += 1
		end
	endfor
	echom l:count.' orphan zettels are moved to '.l:targetdir.'.'
	echom 'You can manually delete '.l:targetdir.' directory.'
endf
