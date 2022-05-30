setlocal foldmethod=indent

" By default Vim will ignore lines beginning with a # character when using indent
" folding. Therefore, our indented block in our factorial.pn file where the first
" line is commented (i.e., starts with a # character) will not fold because it gets
" ignored. However, we can locally set 'foldignore' to nothing in order to tell Vim
" that we don't want it to ignore anything when doing folding.
setlocal foldignore=

