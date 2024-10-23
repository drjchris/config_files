" Plugin manager for not so minimalist.rc"

" Dont forget to install the plugin manager first
" https://github.com/junegunn/vim-plug

call plug#begin()

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
    Plug 'rebelot/kanagawa.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'  }
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'quarto-dev/quarto-vim'

call plug#end()

" Set color theme
colorscheme kanagawa-wave


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

"==== NEOVIDE =====

if exists("g:neovide")
    let g:neovide_cursor_animation_length = 0.05
    let g:neovide_cursor_trail_size = 0.05
    highlight Normal guibg=#1f1f28
endif


"========= FILE TYPE SPECIFIC

" MARKDOWN
autocmd FileType markdown setlocal spell
autocmd FileType markdown setlocal colorcolumn=80
autocmd BufNewFile,BufRead *.md set filetype=markdown " syntax hilight
autocmd FileType markdown inoremap ` ``<Esc>i

augroup markdown_wrap
    autocmd!
    autocmd FileType markdown nnoremap <buffer> <space>ww :call HardWrapText()<CR>
    autocmd FileType markdown nnoremap <buffer> <space>wu :call UnwrapText()<CR>
    autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 expandtab
augroup END



autocmd FileType quarto setlocal spell
autocmd FileType quarto setlocal colorcolumn=80
autocmd BufNewFile,BufRead *.qmd set filetype=quarto
autocmd FileType quarto nnoremap <buffer> <space>ww :call HardWrapText()<CR>
autocmd FileType quarto nnoremap <buffer> <space>wu :call UnwrapText()<CR>
autocmd FileType quarto setlocal tabstop=2 shiftwidth=2 expandtab




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
