
execute pathogen#infect()

syn on
set autoindent
set hls
set nu
set autochdir
set nowrap
set noerrorbells visualbell t_vb=
set t_Co=256

" Continue line comments after enter.
set formatoptions+=r

" XXX: broken for now
" XXX: " fix backspace
" XXX: if &term == "xterm-color"
" XXX:     set t_kb=
" XXX:     fixdel
" XXX: endif
" XXX: if &term == "xterm"
" XXX:     set t_kb=
" XXX:     fixdel
" XXX: endif

if has("multi_byte")
  set encoding=utf-8
  if $TERM == "linux" || $TERM_PROGRAM == "GLterm"
    set termencoding=latin1
  endif
  if $TERM == "xterm" || $TERM == "xterm-color"
    let propv = system("xprop -id $WINDOWID -f WM_LOCALE_NAME 8s ' $0' -notype WM_LOCALE_NAME")
    if propv !~ "WM_LOCALE_NAME .*UTF.*8"
      set termencoding=latin1
    endif
  endif
endif

set backspace=indent,eol,start

let c_space_errors = 1

" Default indent settings
set expandtab
set ts=4
set sw=4

autocmd FileType make setlocal noexpandtab
" autocmd FileType cpp setlocal ts=2
" autocmd FileType cpp setlocal sw=2
autocmd BufRead,BufNewFile *ldap*/*.schema,*ldap*/*.conf set filetype=slapd

" Tabs support
func! QuitAllTabs()
    :tabonly!
    :q! 
endfunc

map <C-n> :tabnew<CR>
map <C-e> :tabe 
map [ :tabp<CR>
map ] :tabn<CR>
map qq :call QuitAllTabs()<CR>


" Search options
set incsearch
set ignorecase
set smartcase
set colorcolumn=80
autocmd FileType java set colorcolumn=120


" Colorscheme
set background=dark
" let g:solarized_termcolors=256
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"
let g:solarized_termtrans=1
let g:solarized_bold=1
let g:solarized_italic=1
let g:solarized_underline=1
colorscheme solarized
" Load nerdtree when no file is given
" autocmd vimenter * if !argc() | NERDTree | endif


