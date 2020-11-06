# neuron.vim
Manage your [Zettelkasten](https://neuron.zettel.page/2011401.html) with the
help of [neuron](https://github.com/srid/neuron) in {n}vim.

**Caution**: This repo is not actively maintained and may not work with the
current version of [neuron](https://neuron.zettel.page). It is highly suggested
to use [fiatjaf/neuron.vim fork](https://github.com/fiatjaf/neuron.vim/)
instead at the moment. Thanks.

![usage-photo](https://lh3.googleusercontent.com/pw/ACtC-3f5ub7ODWrnCYh-ZHDaBk84ZzBjLZ50W32Se4NRqy0kaBOJLGysG8HYYqhpo3hgoc8rABOOrxVqOlA3ut6yB-KGMPuZOI5XQ7D-1nllqCH5oRx28wbXmsOmO2rIdaJFUpTQNTiP-g-vt-i3IAfbwXjC=w1472-h1005-no?authuser=0)

## Requirements
- [neuron](https://github.com/srid/neuron)
- [fzf](https://github.com/junegunn/fzf.vim)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [jq](https://stedolan.github.io/jq/)


## Installation
### Using [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'junegunn/fzf.vim'
Plug 'BurntSushi/ripgrep'
```
```vim
Plug 'ihsanturk/neuron.vim'
```
If you want to use the `dev` branch to test the new features:
```vim
Plug 'ihsanturk/neuron.vim', { 'branch': 'dev' }
```
After saving your changes, remember to source your vimrc `:so $MYVIMRC` and run `:PlugInstall` to install the plugin code.

## Default Mappings
```vim
nm gzn <Plug>EditZettelNew
nm gzb <Plug>NeuronRibStart
nm gzu <Plug>EditZettelLast
nm gzl <Plug>InsertZettelLast
nm gzz <Plug>EditZettelSelect
nm gzi <Plug>InsertZettelSelect
nm gzr <Plug>NeuronRefreshCache
nm gzo <Plug>EditZettelUnderCursor
```
You can disable the mappings with letting the `g:neuron_no_mappings` variable to
1:
```vim
let g:neuron_no_mappings = 1
```

## Caveats, Gotchas and Further Explanation

The "**virtual titles**" displayed alongside the zettel IDs in the screenshot above will only work if using neovim. Standard vim does not support this.

There is no mapping for `:NeuronRibStop` you can stop the server by:
- typing the `:NeuronRibStop` command in ex mode
or
- leaving the vim session (vim will stop the process automatically)

**Common actions and their default mappings:**  
- To search zettels by title: `gzz` (entering the "select a zettel to edit" UI is synonymous with search.)
- Create a new zettel with a random ID filename and open it for editing: `gzn`
- Search for a zettel to insert as a link at the current cursor position: `gzi`
- Add a link at the cursor position to the last zettel viewed: `gzl`
- Go back to edit the last zettel viewed: `gzu`

_Note: The last three mappings work nicely together as a workflow for making connections_.

## Donate
- Bitcoin: `1JmTyije6qxKLRWLyKeUk7DhbUTU9RMBPu`
- USDT: `0xd6af1842c4a1a56ee3494deea57bcbae44af02a9`
- Ethereum: `0xf32A82328fF44009E7419A15E22aCE1A3553aD56`
