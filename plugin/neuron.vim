"           ╭─────────────────────neuron.vim──────────────────────╮
"           Maintainer:     ihsan, ihsanl[at]pm[dot]me            │
"           Description:    Take zettelkasten notes using neuron  │
"           Last Change:    2020 Jul 24 23:40:47 +03, @1595623251 │
"           First Appeared: 2020 May 24 16:20:56 +03, @1590326456 │
"           License:        MIT                                   │
"           ╰─────────────────────────────────────────────────────╯

if exists("g:loaded_neuron_vim")
	finish
endif
let g:loaded_neuron_vim = 1

let g:neuron_no_mappings  = get(g:, 'neuron_no_mappings', 0)
let g:style_virtual_title = get(g:, 'style_virtual_title', 'Comment')
let g:zettel_link_style   = get(g:, 'zettel_link_style', ['[[', ']]'])
let g:fzf_options         = get(g:, 'fzf_options', ['-d',':','--with-nth','2'])
let g:path_jq             = get(g:, 'path_jq', system('which jq | tr -d "\n"'))
let g:path_neuron = get(g:, 'path_neuron', system('which neuron | tr -d "\n"'))

let g:neuron_rib_job = -1

nm <silent> <Plug>NeuronRibStop :<C-U>call rpc#stop_server()<cr>
nm <silent> <Plug>NeuronRibStart :<C-U>call rpc#start_server()<cr>
nm <silent> <Plug>EditZettelNew :<C-U>call neuron#edit_zettel_new()<cr>
nm <silent> <Plug>EditZettelSearchContent :<C-U>NeuronSearchContent<cr>
nm <silent> <Plug>EditZettelLast :<C-U>call neuron#edit_zettel_last()<cr>
nm <silent> <Plug>NeuronRefreshCache :<C-U>call neuron#refresh_cache()<cr>
nm <silent> <Plug>EditZettelSelect :<C-U>call neuron#edit_zettel_select()<cr>
nm <silent> <Plug>InsertZettelLast :<C-U>call neuron#insert_zettel_last()<cr>
nm <silent> <Plug>InsertZettelSelect
			\ :<C-U>call neuron#insert_zettel_select()<cr>
nm <silent> <Plug>EditZettelUnderCursor
			\ :<C-U>call neuron#edit_zettel_under_cursor()<cr>

if !exists("g:neuron_no_mappings") || ! g:neuron_no_mappings
	nm gzn <Plug>EditZettelNew
	nm gzb <Plug>NeuronRibStart
	nm gzu <Plug>EditZettelLast
	nm gzl <Plug>InsertZettelLast
	nm gzz <Plug>EditZettelSelect
	nm gzi <Plug>InsertZettelSelect
	nm gzr <Plug>NeuronRefreshCache
	nm gzo <Plug>EditZettelUnderCursor
	nm gzs <Plug>EditZettelSearchContent
end

com! NeuronRibStart :call rpc#start_server()
com! NeuronRibStop  :call rpc#stop_server()
com! -nargs=* -bang NeuronSearchContent call neuron#search_content(<q-args>, <bang>0)

let g:neuron_errors = {
	\ 'E0': {
		\ 'problem': 'g:cache_zettels not found',
		\ 'suggestions': [
			\ 'press: `gzr` to refresh the cache',
			\ 'run `:call neuron#refresh_cache()`',
		\ ],
	\ },
	\ 'E1': {
		\ 'problem': "neuron not found",
		\ 'suggestions': [
			\ "add: `let g:path_neuron = 'path/to/neuron'` to your vimrc",
		\ ],
	\ },
	\ 'E2': {
		\ 'problem': "jq not found",
		\ 'suggestions': [
			\ "add: `let g:path_jq = 'path/to/jq'` to your vimrc",
		\ ],
	\ },
	\ 'E3': {
		\ 'problem': "no such zettel",
		\ 'suggestions': [],
	\ },
	\ 'E4': {
		\ 'problem': "can't find any zettelids in the line",
		\ 'suggestions': [],
	\ },
	\ 'E5': {
		\ 'problem': "external command failed",
		\ 'suggestions': [],
	\ },
\ }

" : vim: set fdm=marker :
