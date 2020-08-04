func! neuron#insert_zettel_select()
	if !util#cache_exists()
		call neuron#refresh_cache()
	endif
	call fzf#run(fzf#wrap({
		\ 'options': extend(deepcopy(g:fzf_options),['--prompt','Insert Zettel ID: ']),
		\ 'source': util#get_list_pair_zettelid_zetteltitle(),
		\ 'sink': function('util#insert_shrink_fzf'),
	\ }))
endf

func! neuron#search_content(query, fullscreen)
	let cmd_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
	let initial_cmd = printf(cmd_fmt, shellescape(a:query))
	let reload_cmd = printf(cmd_fmt, '{q}')
	let spec = {'dir': g:zkdir,
		\ 'options': [
			\ '--phony',
			\ '--query',
			\ a:query,
			\ '--bind',
			\ 'change:reload:'.reload_cmd
		\]
	\}
	call fzf#vim#grep(initial_cmd,1,fzf#vim#with_preview(spec),a:fullscreen)
endf

func! neuron#edit_zettel_select()
	try
		if !util#cache_exists()
			call neuron#refresh_cache()
		endif
		call fzf#run(fzf#wrap({
			\ 'options': extend(deepcopy(g:fzf_options),['--prompt','Edit Zettel: ']),
			\ 'source': util#get_list_pair_zettelid_zetteltitle(),
			\ 'sink': function('util#edit_shrink_fzf'),
		\ }))
	catch /^jq not found/
		call s:warn("Add: let g:path_jq = 'path/to/jq' to your vimrc.")
	catch /^neuron not found/
		call s:warn("Add: let g:path_neuron = 'path/to/neuron' to your vimrc")
	endtry
endf

func! neuron#edit_zettel_last()
	exec 'e '.s:get_zettel_last()
endf

func! neuron#insert_zettel_last()
	try
		if !util#cache_exists()
			call util#handlerr('E0')
		end
	endtry
	call util#insert(
		\ util#format_zettelid(fnamemodify(s:get_zettel_last(), ':t:r')))
endf

" FIXME ihsanturk#31: vip
func! neuron#edit_zettel_new() " relying on https://github.com/srid/neuron
	exec 'e '.s:run_neuron('new "PLACEHOLDER"')
		\ .' | call search("PLACEHOLDER") | norm"_D'
	startinsert!
	call neuron#refresh_cache()
endf

func! neuron#edit_zettel_new_from_cword() " relying on https://github.com/srid/neuron
	" get the new title
	let title = trim(expand("<cWORD>"), "<>")
	exec 'e '.system('neuron -d '.shellescape(g:zkdir).' new "'.shellescape(title).'"')
	let line = getline('.')
	" insert the new title, two newlines and start editing
	call setline('.', strpart(line, 0, col('.') - 1) . " " . title . strpart(line, col('.') - 1))
	let line = line("$")
	call append(line, "")
	call append(line, "")
	normal G
	startinsert!
	call neuron#refresh_cache()
endf

func! Get_visual_selection()
  try
    let a_save = @a
    silent! normal! gv"ay
    return @a
  finally
    let @a = a_save
  endtry
endfunction

func! neuron#edit_zettel_new_from_visual() " relying on https://github.com/srid/neuron
	" title and content from visual selection (first line = title)

	let vs = split(Get_visual_selection(), "\n")
	let title = vs[0]
	let content = vs[1:]

	exec 'e '.system('neuron -d '.shellescape(g:zkdir).' new "'.shellescape(title).'"')
	"let line = getline('.')
	"call setline('.', strpart(line, 0, col('.') - 1) . " " . title . strpart(line, col('.') - 1))
	let line = line("$")
	call append(line, "")
	call append(line, "")
	call append(line, content)
	normal G
	startinsert!
	call neuron#refresh_cache()
endf


func! neuron#edit_zettel_under_cursor()
	let l:zettel_id = expand('<cword>')
	if util#is_zettelid_valid(l:zettel_id)
		call neuron#edit_zettel(l:zettel_id)
	else
		let l:zettel_id = trim(expand('<cWORD>'), "<>")
		if util#is_zettelid_valid(l:zettel_id)
			call neuron#edit_zettel(l:zettel_id)
		else
			call util#handlerr('E3')
		endif
	endif
endf

func! neuron#get_zettel_title(zettel_id)
	try
		if !util#cache_exists()
			call util#handlerr('E0')
		endif
	endtry
	return g:cache_zettels[a:zettel_id]['zettelTitle']
endf

" TODO: Remove jq dependency find vimscript native solution.
func! neuron#refresh_cache()
	let l:neuron_output = s:run_neuron("query --uri 'z:zettels'")
	let jq_output =
		\ s:run_jq("'reduce .result[] as $i ({}; .[$i.zettelID]=$i)'",
			\ l:neuron_output)
	let g:cache_zettels = json_decode(jq_output)
endf

func! neuron#edit_zettel(zettel_id)
	exec 'edit '.s:expand_zettel_id(a:zettel_id)
endf

func! s:run_neuron(cmd)
	try
		if !executable(g:path_neuron)
			call util#handlerr('E1')
		endif
	endtry
	let l:cmdout = system(g:path_neuron.' -d '.shellescape(g:zkdir).' '.a:cmd)
	if v:shell_error != 0
		call s:warn(l:cmdout)
		call util#handlerr('E5')
	end
	return l:cmdout
endf

func! s:run_jq(cmd, data)
	try
		if !executable(g:path_jq)
			call util#handlerr('E2')
		endif
	endtry
	let l:cmdout = system(g:path_jq.' '.a:cmd, a:data)
	if v:shell_error != 0
		call s:warn(l:cmdout)
		call util#handlerr('E5')
	end
	return l:cmdout
endf

func! s:expand_zettel_id(zettel_id)
	return g:zkdir . a:zettel_id . g:zextension
endf

func! s:get_zettel_last()
	return util#get_file_modified_last(g:zkdir, g:zextension)
endf

func! s:warn(msg)
	echohl WarningMsg
	echo a:msg
	echohl None
	return 0
endf
