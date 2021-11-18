call plug#begin('~/.vim/plugged')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'preservim/nerdtree'
Plug 'mattn/emmet-vim'
Plug 'ThePrimeagen/harpoon'
Plug 'ThePrimeagen/refactoring.nvim'
call plug#end()

let mapleader = " "

" Enable easy split window navigation
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" Clear search on ESC
nnoremap <ESC> :nohlsearch<CR><ESC>

" save on Ctrl+s
nnoremap <C-S> :w<CR>

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup negosaki
        autocmd!
        autocmd BufWritePre * :call TrimWhitespace()
        autocmd FileType c,cpp,java,scala,javascript,javascriptreact,typescript,typescriptreact let b:comment_leader = '//'
        autocmd FileType sh,ruby,python   let b:comment_leader = '#'
        autocmd FileType conf,fstab       let b:comment_leader = '#'
        autocmd FileType tex              let b:comment_leader = '%'
        autocmd FileType mail             let b:comment_leader = '>'
        autocmd FileType vim              let b:comment_leader = '"'
        " jump to the last position when
        " reopening a file
        if has("autocmd")
            au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        endif
        " handle nasm syntax in .asm files
        au BufRead,BufNewFile *.asm set filetype=nasm
               autocmd FileType asm              let b:comment_leader = ';'
        augroup END

function! CommentToggle()
      execute ':silent! s/\([^ ]\)/' . escape(b:comment_leader,'\/') . ' \1/'
      execute ':silent! s/^\( *\)' . escape(b:comment_leader,'\/') . ' \?' . escape(b:comment_leader,'\/') . ' \?/\1/'
        endfunction

map <F7> :call CommentToggle()<CR>
