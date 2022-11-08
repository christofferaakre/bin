-- set colorscheme
vim.opt.termguicolors = true

vim.cmd("augroup qs_colors \n" ..
  "autocmd! \n" ..
  "autocmd ColorScheme * highlight QuickScopePrimary guifg='#5fffff' gui=underline ctermfg=155 cterm=underline \n" ..
  "autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline \n" ..
"augroup END\n"
)

vim.cmd("colorscheme gruvbox")
-- vim.g["gruvbox_contrast_dark"] = "hard"

vim.cmd("highlight Normal guibg=None")
-- vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")
-- vim.cmd("highlight SignColumn ctermbg=NONE guibg=NONE")
-- vim.cmd("highlight LineNr ctermbg=NONE guibg=NONE")
-- vim.cmd("hi NonText guibg=NONE ctermbg=NONE")
