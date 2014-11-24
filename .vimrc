" ptrckbrwn's .vimrc
" Maintainer: Patrick Brown <http://pab.io/>
"
" Table of Contents
" -----------------
"
" I.    Plugins
" II.   Leader
" III.  Language specific settings
" IV.   Remaps
" V.    Tabs
" VI.   Moving/Searching
" VII.  Text wrapping
" VIII. Theme
" IX.   Misc
" X.    Helper functions
" XI.   Plugin settings

" I. Plugins ------------------------------------------------------------------

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" Vim Extensions
Plugin 'tpope/vim-sensible'
Plugin 'sjl/gundo.vim'
Plugin 'chriskempson/base16-vim'
Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'

" Linting/Completion
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neosnippet.vim'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'scrooloose/syntastic'

" File Exploration
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'mileszs/ack.vim'

" Text Manipulation
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-commentary'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" OS
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-eunuch'

" Ruby on Rails
Plugin 'vim-ruby/vim-ruby'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rvm'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-markdown'
Plugin 'pangloss/vim-javascript'
Plugin 'othree/html5.vim'

call vundle#end()
filetype plugin indent on

" II. Leader ------------------------------------------------------------------

let mapleader = ","
let g:mapleader = ","

" III. Language specific settings ---------------------------------------------

" Ruby
autocmd FileType ruby let b:dispatch = 'rspec %'

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

" Tabs
nnoremap <leader>t :tabnew<CR>

" Gundo
nnoremap <leader>u :GundoToggle<CR>

" Ack
nnoremap <leader>/ :Ack<space>

" Git
nnoremap <leader>g :Git<space>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gci :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Git l<CR>

" Zeus
nnoremap <leader>zc :Start zeus console<CR>
nnoremap <leader>zdbs :Dispatch zeus rake db:migrate:status<CR>
" no <CR> on purpose below
nnoremap <leader>zdbm :Dispatch zeus rake db:migrate

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
set textwidth=80
set colorcolumn=72,80
set formatoptions=qrn1

" VIII. Theme -----------------------------------------------------------------

colorscheme base16-eighties
set bg=dark
set t_Co=256

" Set extra options when running in GUI mode.
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r
    set guitablabel=%M\ %t
    set guifont=Menlo:h12
endif

" IX. Misc --------------------------------------------------------------------

set shell=zsh
filetype plugin on
filetype indent on
syntax enable
set cursorline
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

" Gundo
let g:gundo_right = 1

" Rspec
let g:rspec_command = "compiler rspec | set makeprg=zeus | Make rspec {spec}"
" let g:rspec_command = "Dispatch rspec {spec}"

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
