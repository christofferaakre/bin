-- set python3 path
vim.g["python3_host_prog"] = "~/.local/venv/nvim/bin/python3"

require("sets")
require("plugins")

require("keybindings")
require("colors")
require("lsp")
require("syntax_highlighting")
require("comment")
require('context')

vim.cmd('source ~/.config/nvim/after/vimscript.vim')
