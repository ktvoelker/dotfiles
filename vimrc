
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " Allow backspacing over everything in insert mode
set nohlsearch
set novisualbell
set history=50          " keep 50 lines of command history
set ruler               " Show the cursor position all the time
set showmode
set hidden
set autoindent
set loadplugins

set wildmode=longest:full
set wildmenu

" The empty entry matches files without a suffix.
set suffixes+=,,.hi,.ps,.pdf

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set equalalways

" Disable menubar and toolbar
set guioptions-=m
set guioptions-=T

" Disable all scrollbars
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions-=b

if v:lang =~ "^ko"
  set fileencodings=euc-kr
  set guifontset=-*-*-medium-r-normal--16-*-*-*-*-*-*-*
elseif v:lang =~ "^ja_JP"
  set fileencodings=euc-jp
  set guifontset=-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*
elseif v:lang =~ "^zh_TW"
  set fileencodings=big5
  set guifontset=-sony-fixed-medium-r-normal--16-150-75-75-c-80-iso8859-1,-taipei-fixed-medium-r-normal--16-150-75-75-c-160-big5-0
elseif v:lang =~ "^zh_CN"
  set fileencodings=gb2312
  set guifontset=*-r-*
endif
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
  set fileencodings=utf-8,latin1
endif

syntax on

filetype plugin on
filetype indent on

colorscheme zellner

au BufRead,BufNewFile *.als setfiletype alloy4

" Dvorak mode
noremap d h
noremap h j
noremap j n
noremap k d
noremap l t
noremap n l
noremap t k

" Ctrl-h jump to the definition of the tag under the cursor
noremap <C-h> :ta <C-R>=expand("<cword>")<CR><CR>

" Alt-b pops up a buffer selector
noremap <M-b> :TSelectBuffer<CR> 

" Navigate spatially between vim windows with Alt
noremap <M-d> <C-W>h
noremap <M-h> <C-W>j
noremap <M-t> <C-W>k
noremap <M-n> <C-W>l

" Use :q to quit the program, not the vim window.
cabbrev q qall
cabbrev wq wqall

