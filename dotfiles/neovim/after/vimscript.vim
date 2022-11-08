"TODO: Replace this vimscript with lua

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup negosaki
        autocmd!
        autocmd BufWritePre * :call TrimWhitespace()
        autocmd FileType c,cpp,java,scala,javascript,javascriptreact,typescript,typescriptreact let b:comment_leader = '//'
        autocmd FileType rust let b:comment_leader = '//'
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

        " handle nasm syntax in .inc files
        au BufRead,BufNewFile *.inc set filetype=nasm
               autocmd FileType nasm              let b:comment_leader = ';'

        " handle glsl syntax in .vs files
        au BufRead,BufNewFile *.vs,*.fs set filetype=glsl
               autocmd FileType glsl             let b:comment_leader  = '//'

        au BufRead,BufNewFile *.lang set filetype=lang
               autocmd FileType lang              let b:comment_leader = '#'

        autocmd BufWritePre *.py :call Black()

        augroup END


xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Vimtex
let g:vimtex_view_general_viewer = 'evince'
let g:vimtex_quickfix_open_on_warning = 0
" let g:vimtex_quickfix_mode = 0
"
let g:vimtex_compiler_engine = 'lualatex'
let g:vimtex_complete_enabled = 1

