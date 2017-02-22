"setting pathogen
execute pathogen#infect()
filetype plugin indent on

set autoindent
set smartindent

set textwidth=70
set wrap
set nowrapscan

set visualbell
set ruler
set hlsearch
set number
set wildmode=full

set ts=4 sw=4 et
set listchars=extends:⇒,precedes:⇐,tab:»·,trail:␣,eol:¬
set list

syntax enable

"setting colorscheme
set background=dark
if has('gui_running')
    colorscheme solarized
else
    colorscheme bubblegum-256-dark
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=0
    let g:airline_theme='bubblegum'
endif

""setting indent guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_default_mapping=1
let g:indent_guides_auto_colors=0
let g:indent_guides_guide_size=4

"setting syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_loc_list_height=4
let g:syntastic_python_checkers=['flake8']

"setting airline
set laststatus=2
let g:airline#extensions#tabline#tab_nr_type=2 
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'
let g:airline#extensions#tabline#switch_buffers_and_tabs=1
let g:airline#extensions#tabline#buffer_nr_show = 1

set nocompatible
set history=50
set updatetime=2000
set grepprg=grep\ -nsHE
set backspace=indent,eol,start
set mouse=a

let mapleader = '\'
let maplocalleader = '\'

"setting NERDTree
autocmd VimEnter * NERDTree
autocmd VimEnter * vertical resize -10
nmap <Leader>nt :NERDTreeToggle

" Folding
set foldmethod=marker

" map f3 and f4 to cumulatively toggle spellchecking in english and german respectively
set spelllang=
function! SetSpelllang(lang)"{{{
    if strridx(&spelllang, a:lang) == -1
        execute "set spl+=".a:lang
        echo "activating spell checking for: ".a:lang." -- the following language(s) are now active: ".&spelllang
    else
        execute "set spl-=".a:lang
        echo "deactivating spell checking for: ".a:lang." -- the following language(s) are now active: ".&spelllang
    endif
    set spell
endfunction"}}}
map <f3> :call SetSpelllang("en_us")<cr>
map <f4> :call SetSpelllang("de")<cr>

