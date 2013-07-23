let s:home = expand('~')
let s:vimrc = resolve(s:home . '/.vimrc')
let s:srcdir = fnamemodify(s:vimrc, ":p:h")

let &runtimepath=substitute(&runtimepath, s:home.'/\.vim', s:srcdir.'/', 'g')

" http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/
call pathogen#infect()

autocmd FileType * set shiftwidth=4|set smarttab|set softtabstop=4|set expandtab|set autoindent|set smartindent|set number|set modeline|set ls=2

syntax on

" filetypes
filetype plugin on
filetype indent on

map :hex :%!xxd<CR>
map :nhex :%!xxd -r<CR>

for f in split(glob(s:srcdir.'/rc.d/*'), '\n')
    exe 'source' f
endfor

unlet s:home
unlet s:vimrc
unlet s:srcdir
