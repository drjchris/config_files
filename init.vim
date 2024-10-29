" lugin manager for not so minimalist.rc"

call plug#begin()

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
    Plug 'rebelot/kanagawa.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'  }
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'quarto-dev/quarto-vim'
    Plug 'vimwiki/vimwiki'

    " code completion
    Plug 'neoclide/coc.nvim', {'branch': 'release'}


call plug#end()

" Set color theme
colorscheme kanagawa-wave

" set space as the leader key
let mapleader=" "

" Minimalist .vimrc

" Set spaces instead of tabs, with a width of 4 spaces
set expandtab
set shiftwidth=4
set softtabstop=4

" remove wrapping
set nowrap

" Set number format with 3 columns always
set number
set numberwidth=4

" Highlight the current line
set cursorline

" Always have at least 4 lines below the cursor
set scrolloff=4

" Enable auto-close pairs (using a simple mapping)
inoremap ( ()<Esc>i
inoremap { {}<Esc>i
inoremap [ []<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i

" Do not highlight search results after a search
set nohlsearch

" telescope remaps
nnoremap <space>ff <cmd>Telescope find_files<cr>
nnoremap <space>fg <cmd>Telescope live_grep<cr>
nnoremap <space>fb <cmd>Telescope buffers<cr>
nnoremap <space>fh <cmd>Telescope help_tags<cr>


" Set transparent background
highlight Normal ctermbg=none guibg=none

" Enable system clipboard usage for copy-paste
set clipboard=unnamedplus

" Enable file type detection
filetype on

" Enable syntax highlighting
syntax on

" Recognise Markdown files for filetype-specific settings
filetype plugin on


" ===== COC CODE COMPLETION

" Map <Right> to confirm a selection in CoC's completion menu if it is visible
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
" Use <Tab> and <Shift-Tab> for navigation
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set signcolumn=yes:1

"==== NEOVIDE =====

if exists("g:neovide")
    let g:neovide_cursor_animation_length = 0.05
    let g:neovide_cursor_trail_size = 0.05
    highlight Normal guibg=#1f1f28
endif


"========= FILE TYPE SPECIFIC

" MARKDOWN
autocmd BufNewFile,BufRead *.md set filetype=markdown " syntax hilight
autocmd FileType markdown setlocal spell
autocmd FileType markdown setlocal colorcolumn=80
autocmd FileType markdown inoremap ` ``<Esc>i

augroup markdown_wrap
    autocmd!
    autocmd FileType markdown nnoremap <buffer> <space>tw :call HardWrapText()<CR>
    autocmd FileType markdown nnoremap <buffer> <space>tu :call UnwrapText()<CR>
    autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 expandtab
augroup END




" PYTHON
autocmd BufNewFile,BufRead *.py set filetype=python
autocmd FileType python nnoremap <buffer> <leader>/ :call ToggleComment()<CR>
autocmd FileType python vnoremap <buffer> <leader>/ :call ToggleComment()<CR>



" QUARTO
autocmd FileType quarto setlocal spell
autocmd FileType quarto setlocal colorcolumn=80
autocmd BufNewFile,BufRead *.qmd set filetype=quarto
autocmd FileType quarto nnoremap <buffer> <space>ww :call HardWrapText()<CR>
autocmd FileType quarto nnoremap <buffer> <space>wu :call UnwrapText()<CR>
autocmd FileType quarto setlocal tabstop=2 shiftwidth=2 expandtab


" ===== VIM WIKI ====="
set nocompatible
let g:vimwiki_list = [{'path': '~/Library/CloudStorage/OneDrive-UniversityofBrighton/Documents/vimwiki',
                      \ 'syntax': 'markdown', 'ext': 'md'}]


" PYTHON
autocmd FileType python setlocal colorcolumn=80



" ======= SCRIPTS ====="

function! HardWrapText()
    " Set the text width to 80 temporarily
    let l:original_tw = &textwidth
    set textwidth=78

    " Apply formatting for the current paragraph
    normal! gqap

    " Restore the original text width
    let &textwidth = l:original_tw
endfunction



function! UnwrapText()
    " Store the original value of 'textwidth'
    let l:original_tw = &textwidth
    " Disable text wrapping by setting 'textwidth' to 0
    set textwidth=0

    " Visually select the current paragraph and join all lines into one
    normal! vipJ

    " Use substitute to split after every period (.)
    silent! %s/\.\s\+/\.\r/g

    " Restore the original 'textwidth'
    let &textwidth = l:original_tw
endfunction


function! ToggleComment()
    " Get the mode to determine whether to operate on a single line or a visual selection
    if mode() == 'v' || mode() == 'V'
        " In visual mode, operate on the selected lines
        '<,'>s/^\s*# \?/&/
        '<,'>s/^\(\s*\)# /\1/
        normal gv
    else
        " Save the current cursor position for normal mode
        let currentPos = getpos('.')
        
        " Check if the current line starts with '# ' and toggle it
        if getline('.') =~ '^\s*# '
            execute 'silent! s/^\s*# //'
        else
            execute 'silent! s/^\s*/&# /'
        endif

        " Restore the cursor position
        call setpos('.', currentPos)
    endif
endfunction
