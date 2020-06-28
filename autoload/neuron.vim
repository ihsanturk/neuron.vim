func! neuron#insert_zettel_select()
	try
		if !exists('g:cache_zettels') || empty('g:cache_zettels')
			call neuron#refresh_cache()
		endif
		call fzf#run(fzf#wrap({
			\ 'options': extend(deepcopy(g:fzf_options),['--prompt','Insert Zettel ID: ']),
			\ 'source': util#get_list_pair_zettelid_zetteltitle(),
			\ 'sink': function('util#insert_shrink_fzf'),
		\ }))
	catch /^neuron not found/
		call s:warn("Add: let g:path_neuron = 'path/to/neuron' to your vimrc")
	catch /^jq not found/
		call s:warn("Add: let g:path_jq = 'path/to/jq' to your vimrc.")
	endtry
endf

func! neuron#edit_zettel_select()
	try
		if !exists('g:cache_zettels') || empty('g:cache_zettels')
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
	call util#insert(
		\ util#get_formatted_zettelid(fnamemodify(s:get_zettel_last(), ':t:r')))
	" call util#insert('<'.fnamemodify(s:get_zettel_last(), ':t:r').'>')
endf

func! neuron#edit_zettel_new() " relying on https://github.com/srid/neuron
	exec 'e '.system('neuron new "PLACEHOLDER"')
		\ .' | call search("PLACEHOLDER") | norm"_D'
	startinsert!
	call neuron#refresh_cache()
endf

func! neuron#edit_zettel_under_cursor()
	let l:zettel_id = expand('<cword>')
	if util#is_zettelid_valid(l:zettel_id)
		call neuron#edit_zettel(l:zettel_id)
	else
		throw "No such zettel"
	endif
endf

func! neuron#get_zettel_title(zettel_id)
	if !exists('g:cache_zettels') || empty('g:cache_zettels')
		throw "g:cache_zettels not found!"
	endif
	return g:cache_zettels[a:zettel_id]['title']
endf

" TODO: Remove jq dependency find vimscript native solution.
func! neuron#refresh_cache()
	let l:neuron_output = s:run_neuron("query --uri 'z:zettels'")
	let jq_output =
		\ s:run_jq("'reduce .result[] as $i ({}; .[$i.id]=$i)'", l:neuron_output)
	let g:cache_zettels = json_decode(jq_output)
endf

func! neuron#edit_zettel(zettel_id)
	exec 'edit '.s:expand_zettel_id(a:zettel_id)
endf

func! s:run_neuron(cmd)
	if !executable(g:path_neuron)
		throw 'neuron not found'
	endif
	return system(g:path_neuron.' '.a:cmd)
endf

func! s:run_jq(cmd, ...)
	if !executable(g:path_jq)
		throw "jq not found"
	endif
	return system(g:path_jq.' '.a:cmd, a:1) " in this case, a:1 is stdin
endf

func! s:expand_zettel_id(zettel_id)
	return g:zkdir . a:zettel_id . g:zextension
endf

func! s:get_zettel_last()
	return util#get_file_modified_last(g:zkdir, g:zextension)
endf

func! s:warn(msg)
	echohl WarningMsg
	echom a:msg
	echohl None
	return 0
endf
