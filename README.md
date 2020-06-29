# neuron.vim
Manage your [Zettelkasten](https://neuron.zettel.page/2011401.html) with the
help of [neuron](https://github.com/srid/neuron) in {n}vim.

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

There is no mapping for `:NeuronRibStop` you can stop the server by
- typing this command in ex mode
or
- leaving the vim session (vim will stop the process automatically)
