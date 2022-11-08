vim.g["rustfmt_autosave"] = 1

local map = vim.api.nvim_set_keymap
map('n', '<leader>rr', ':RustRun<CR>', { noremap = true, silent = false})
map('n', '<leader>rt', ':RustTest<CR>', { noremap = true, silent = false})
