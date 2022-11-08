" Hex read
nmap <Leader>hr :%!xxd -g 1<CR> :set filetype=xxd<CR>

" Hex write
nmap <Leader>hw :%!xxd -g 1 -r<CR> :set binary<CR> :set filetype=<CR>

augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd -g 1
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -g 1 -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd -g 1
  au BufWritePost *.bin set nomod | endif
augroup END
