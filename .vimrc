"
" Bindu's vimrc file based on "An example for a vimrc file."
"
" Maintainer:	Bindu Wavell
" Last change:	2002 Oct 07
"

"autocmd BufEnter * :lcd %:p:h

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
filetype on
filetype plugin on
set bs=2		        " allow backspacing over everything in insert mode
set ai			        " always set autoindenting on
set nobackup	        " don't keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			            " than 50 lines of registers
set history=1000		    " keep 50 lines of command line history
set ruler		        " show the cursor position all the time
set background=dark     " Make sure we have a nice dark background
set laststatus=2        " Make sure the status line is always displayed

set cf " enable error files and error jumping
set clipboard+=unnamed " turns out I do like is sharing windows clipboard
set ffs=unix,mac,dos " support all three, in this order

set viminfo+=! " make sure it can save viminfo
set isk+=_,$,@,%,#,- " none of these should be word dividers, so make

" Try and enable color for xterms
if &term =~ 'xterm'
    if has("terminfo")
        set t_Co=8
        set t_Sf=[3%p1%dm
        set t_Sb=[4%p1%dm
    else
        set t_Co=8
        set t_Sf=[3%dm
        set t_Sb=[4%dm
    endif
endif

" Switch syntax highlighting on
syntax enable


" Make external commands work through a pipe instead of a pseudo-tty
"set noguipty

" set the X11 font to use
" set guifont=-misc-fixed-medium-r-normal--14-130-75-75-c-70-iso8859-1

" Display bufnr:filetype (dos,unix,mac) in status line
set statusline=%<%n:%f%h%m%r%=%{&ff}\ %l,%c%V\ %P

" Hide the mouse pointer while typing
" The window with the mouse pointer does not automatically become the active window
" Right mouse button extends selections
" Turn on mouse support
set mousehide
set nomousefocus
set mousemodel=extend
set mouse=a

" Show paren matches
" For 5 tenths of a second
set showmatch
set matchtime=5

" Setup tabs for 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set shiftround
set expandtab

" Setup auto wrapping
set textwidth=78

" Setup indenting
set autoindent

" Enable wild menus
set wildmenu

" Nice default colorscheme
"colorscheme vividchalk
colorscheme ps_color

" === COMMAND MAPPINGS ===
" DOS to Unix conversion (remove ^M)
" added mark (m) so we end up where we started
noremap <Leader>D mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm

" VIM Ascii table
"noremap <Leader>A :help digraph-table<CR>

" Edit a file in the same directory as the current file
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Retag the parent of the current folder
"noremap <Leader>r :!fndtags<CR>

" Map H to stop highlighting search matches
"noremap H :set hlsearch!<CR>

" Make shift-insert work like in Xterm
noremap <S-Insert> <MiddleMouse>
noremap! <S-Insert> <MiddleMouse>

" === COMMAND/FOLD MAPPINGS ===
" Fold Block - anywhere in or on block except closing brace
noremap fb j[[zfaB

" Fold Comment - anywhere in or on a block comment
noremap fc j[*zf]*

" Fold Mark - Fold to the a mark
noremap fm zf'a

" Delete a Fold
noremap fd zd

" === NORMAL MAPINGS ===
" make '<map> goto exact location of map (rather than the
" beginning of the line where the map is)
nnoremap ' `

" allow . to execute once for each line of a visual selection 
vnoremap . :normal .<CR>

" allow ` to execute the contents of the a register once 
" for each line of a visual selection 
vnoremap ` :normal @a<CR>

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim UI

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ruler " Always show current positions along the bottom 
set cmdheight=2 " the command bar is 2 high
set number " turn on line numbers
set backspace=2 " make backspace work normal
set whichwrap+=<,>,h,l  " backspace and cursor keys wrap to
set shortmess=atI " shortens messages to avoid 'press a key'
set report=0 " tell us when anything is changed via :...
set noerrorbells " don't make noise
" make the splitters between windows be blank
set fillchars=vert:\ ,stl:\ ,stlnc:\

" === PLUGIN SETTINGS ===

" MiniBufExplorer
"let g:miniBufExplModSelTarget = 1
"let g:miniBufExplorerMoreThanOne = 0
"let g:miniBufExplModSelTarget = 0
"let g:miniBufExplUseSingleClick = 1
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplVSplit = 15
"let g:miniBufExplSplitBelow=1

"               To enable the optional mapping of Control + Vim Direction Keys 
"               [hjkl] to window movement commands, you can put the following into 
"               your .vimrc:
"
"let g:miniBufExplMapWindowNavVim = 1
"
"               To enable the optional mapping of Control + Arrow Keys to window 
"               movement commands, you can put the following into your .vimrc:
"
"let g:miniBufExplMapWindowNavArrows = 1
"
"               To enable the optional mapping of <C-TAB> and <C-S-TAB> to a 
"               function that will bring up the next or previous buffer in the
"               current window, you can put the following into your .vimrc:
"
"let g:miniBufExplMapCTabSwitchBufs = 1

"map <c-w><c-t> :WMToggle<cr>

map <leader>tn :tabnew %<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 

map <F8> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>


hi MBENormal         guifg=cyan
hi MBEChanged        guifg=red
hi MBEVisibleNormal  guibg=darkblue guifg=yellow
hi MBEVisibleChanged guibg=red      guifg=yellow



" === AUTOCMD SETTINGS ===
" Only do this part when compiled with support for autocommands.
if has("autocmd")

" In text files, always limit the width of text to 78 characters
autocmd BufRead *.txt set tw=78

augroup cprog
" Remove all cprog autocommands
au!

" When starting to edit a file:
"   For C and C++ files set formatting of comments and set C-indenting on.
"   For other files switch it off.
"   Don't change the order, it's important that the line with * comes first.
autocmd FileType *      set formatoptions=tcql nocindent comments&
autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
autocmd FileType python set omnifunc=pythoncomplete#Complete

set tags=./tags,../tags,../../tags,../../../tags,../../../../tags
augroup END

" Automatically save view information about each file that is edited
" and restore the settings (persists between VIM invocations.)
au BufWinLeave *.c,*.cpp,*.h mkview
au BufWinEnter *.c,*.cpp,*.h silent loadview

endif " has("autocmd")
set foldmethod=marker
set wmh=0
set noequalalways

set dir=~/.vim/swap
set nobackup writebackup

" Spelling
source ~/.vim/spelling.vim

" Additional abbreviations
iabbr abd Abdulmajed Dakkak
iabbr abe adakkak@eng.utoledo.edu


set spell
set spelllang=en_us

" Mappings
source ~/.vim/mappings

map ,n :w:!asciidoc -a asciimath  %
map ,rp :w:!pdflatex %
map ,rl :w:!latex %
map ,rt :w:!tex %
map ,df :!evince %<.pdf &
map ,m :w:!pdflatex %:!evince %<.pdf &
map ,k :w:!pdflatex %:!kpdf %<.pdf &
map ,bib :!bibtex %<
map ,p :w:!python %
map ,r :w:!ruby %
map ,l :w:silent! call Tex_RunLaTeX( ) :silent! call Tex_ViewLaTeX( ) &
map 2l :w<CR>:!txt2tags -t tex % ; xelatex %<.tex ; open %<.pdf<CR>
map 2h :w<CR>:!txt2tags -t html %<CR>
map 2t :w<CR>:!txt2tags -t txt % <CR>



" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse latex-suite. Set your grep
" program to alway generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on


if has("unix")
map ,w :split <C-R>=expand("%:p:h") . "/" <CR>
else
map ,w :split <C-R>=expand("%:p:h") . "\" <CR>
endif

let tlist_tex_settings   = 'latex;s:sections;g:graphics;l:labels'
let tlist_make_settings  = 'make;m:makros;t:targets'
let g:tex_flavor = "pdflatex"
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_ViewRule_pdf = 'evince '
set winaltkeys=no

set cursorline
"set cursorcolumn

set formatprg=par\ -jw79
map ,b {v}!par -jw60
vmap ,q !par -jw60

" Haskell Functionality
" use ghc functionality for haskell files
au Bufenter *.hs compiler ghc

set tags+=~/.vim/cpp
set tags+=$HOME/.vim/tags/python.ctags
