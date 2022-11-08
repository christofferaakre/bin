vim.opt.encoding = "utf-8"

vim.opt.cmdheight = 2

-- always block cursor
vim.opt.guicursor = ""

-- relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- no annoying beep
vim.opt.errorbells = false
vim.opt.visualbell = true

-- indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- swap files and buffers
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.hidden = true


-- completion
vim.opt.completeopt = {"menuone", "noinsert", "noselect"}

-- sign/color column
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- status bar
vim.opt.laststatus = 2
vim.opt.ruler = true

-- folding
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

--miscellaneous
vim.opt.showmode = false
vim.opt.wrap = false
vim.opt.scrolloff = 8

-- clipboard
vim.opt.clipboard = vim.opt.clipboard + "unnamedplus"

-- mouse integration
vim.opt.mouse = "a"

--vim.opt.cmdheight = 2
vim.opt.updatetime = 50
--vim.opt.shortmess = vim.opt.shortmess + "c"

vim.g["rustfmt_autosave"] = 1
