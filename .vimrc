" ptrckbrwn's .vimrc
" Maintainer: Patrick Brown <http://pab.io/>
"
" Table of Contents
" -----------------
"
" I.    NeoBundle
" II.   Leader
" III.  Language specific settings
" IV.   Remaps
" V.    Tabs
" VI.   Moving/Searching
" VII.  Text wrapping
" VIII. Theme
" IX.   Misc
" X.    Helper functions
" XI.   Plug in settings

" I. NeoBundle ----------------------------------------------------------------

if has('vim_starting')
  set runtimepath+=/Users/ptrckbrwn/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('/Users/ptrckbrwn/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

" Shougo
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'

" Tim Pope
NeoBundle 'tpope/vim-sensible'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-eunuch'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-rvm'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-speeddating'

" Steve Losh
NeoBundle 'sjl/gundo.vim'

" Martin Grenfell
NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/nerdcommenter'

NeoBundle 'ptrckbrwn/vim-vlux'
NeoBundle 'tomtom/tlib_vim'
NeoBundle 'edkolev/tmuxline.vim'
NeoBundle 'MarcWeber/vim-addon-mw-utils'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'chriskempson/base16-vim'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'othree/html5.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'elixir-lang/vim-elixir'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'jnwhiteh/vim-golang'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'thoughtbot/vim-rspec'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'derekwyatt/vim-scala'

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

" II. Leader ------------------------------------------------------------------

let mapleader = ","
let g:mapleader = ","

" III. Language specific settings ---------------------------------------------

" Go
autocmd FileType go let b:dispatch = 'go test %:p:h'
autocmd FileType go nnoremap <leader>f :Fmt<CR>
autocmd FileType go compiler go

" Ruby
autocmd FileType ruby let b:dispatch = 'rspec %'

" Python
autocmd FileType python let b:dispatch = 'nosetest %'

" IV. Remaps ------------------------------------------------------------------

" Escape
imap <leader><leader> <Esc>

" Dispatch
nnoremap <leader>d :Dispatch<CR>

" Rspec
map <Leader>r :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Gundo
nnoremap <leader>u :GundoToggle<CR>

" Ack
nnoremap <leader>/ :Ack<space>

" Git
nnoremap <leader>g :Git<space>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gci :Gcommit<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Git l<CR>

" NERDTree
map <leader>n :NERDTree<CR>

" Paste mode
set pastetoggle=<leader>p

" Increment/decrement
nnoremap <C-i> <C-a>
nnoremap <C-d> <C-x>

" Clear search
nnoremap <leader><space> :noh<cr>

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" V. Tabs ---------------------------------------------------------------------

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab "softtabs

" VI. Moving/Searching --------------------------------------------------------

set ignorecase
set smartcase
set gdefault
set showmatch
set hlsearch

" VII. Text wrapping ----------------------------------------------------------

set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=79

" VIII. Theme -----------------------------------------------------------------

colorscheme base16-atelierdune
set t_Co=256
set list
set listchars=tab:▸\ ,eol:¬

" Set extra options when running in GUI mode.
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set guitablabel=%M\ %t
    set guifont=Menlo:h14
endif

" IX. Misc --------------------------------------------------------------------

set shell=zsh
filetype plugin on
filetype indent on
syntax enable
set cursorline
set nocompatible
set nu
set lazyredraw
set showmode
set spell
set hidden
set wildmode=list:longest
set visualbell
set ttyfast
set undofile
set undodir=~/.vim/undo//
set ffs=unix,dos,mac
set dir=~/.vim/swp//

" X. Helper functions ---------------------------------------------------------

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" XI. Plug in settings --------------------------------------------------------

" Vlux
let g:vlux_sunrise = 7
let g:vlux_sunset = 19

" Gundo
let g:gundo_right = 1

" Lightline
let g:lightline = {
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component': {
  \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
  \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
  \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
  \ },
  \ 'component_visible_condition': {
  \   'readonly': '(&filetype!="help"&& &readonly)',
  \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
  \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
  \ }
  \ }

" Tmuxline
let g:tmuxline_powerline_separators = 0
let g:tmuxline_theme = 'lightline_visual'

" Rspec
let g:rspec_command = "compiler rspec | set makeprg=zeus | Make rspec {spec}"

" Neocomplete
" Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
