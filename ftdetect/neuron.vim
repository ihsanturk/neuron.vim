let g:zextension = get(g:, 'zextension', '.md')
let g:zkdir = get(g:, 'zkdir', $HOME.'/zettelkasten/')

if exists('b:did_ftdetect') | finish | endif
aug neuron
	exec ':au! BufRead,BufNewFile '.g:zkdir.'*'.g:zextension.' call s:set_filetype()'
	exec ':au! BufWritePost '.g:zkdir.'*'.g:zextension.
		\ ' call neuron#refresh_cache()'
aug END
let b:did_ftdetect = 1

func! s:set_filetype()
	" TODO: Activate markdown and neuron filetype at the same time.
	" exec ':au! BufRead,BufNewFile '.g:zkdir.'*'.g:zextension.' setf=neuron'
	" runtime! ftplugin/markdown.vim
	" runtime! ftplugin/markdown_*.vim ftplugin/markdown/*.vim
	call s:add_virtual_titles()
endf

func! s:add_virtual_titles()
	" TODO: Use util#filter_zettels_in_line function to get links.
	" TODO: Get ids from cache.
	let l:re_neuron_link = '<\([0-9a-zA-Z_-]\+\)\(?cf\)\?>'
	let l:re_neuron_link_alt = '\[\[\([0-9a-zA-Z_-]\+\)\]\]'
	if !exists('*nvim_buf_set_virtual_text')
		return
	endif
	call nvim_buf_clear_namespace(0, 0, 0, line('$'))
	let l:lnum = 0
	for line in getbufline(bufname('%'), 1, "$")
		let l:line_matches = matchlist(line, l:re_neuron_link)
		if (empty(l:line_matches))
			let l:line_matches = matchlist(line, l:re_neuron_link_alt)
		endif
		if(!empty(l:line_matches))
			let l:zettel_id = l:line_matches[1]
			if util#is_zettelid_valid(l:zettel_id)
				let l:title = neuron#get_zettel_title(l:zettel_id)
				" TODO: Use
				" nvim_buf_set_extmark({buffer}, {ns_id}, {id}, {line}, {col}, {opts})
				" function instead of nvim_buf_set_virtual_text. Check this link for
				" help https://github.com/neovim/neovim/blob/e628a05b51d4620e91662f857d29f1ac8fc67862/runtime/doc/api.txt#L1935-L1955
				call nvim_buf_set_virtual_text(0,0,
					\ l:lnum, [[l:title, g:style_virtual_title]],{})
			endif
		endif
		let l:lnum += 1
	endfor
endf
