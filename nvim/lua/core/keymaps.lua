-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap.set
local builtin = require('telescope.builtin')

keymap("n" , "<esc>", "<CMD>nohl<CR>", {desc = "Erase highlight from research"})
keymap("n" , "<leader>md", "<CMD>Oil<CR>", {desc = "Start Oil"})


keymap('n', '<leader><leader>', builtin.find_files, { desc = 'Telescope find files' })
keymap('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
keymap('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
keymap('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
