-- Leader key
local keymap = vim.keymap.set
local tlscpbuiltin = require('telescope.builtin')

-- Vanilla
keymap("n" , "<esc>", "<CMD>nohl<CR>", {desc = "Erase highlight from research"})

-- Oil
keymap("n" , "<leader>md", "<CMD>Oil<CR>", {desc = "Start Oil"})

-- 42Header
keymap("n" , "<leader>h", "<CMD>Stdheader<CR>", {desc = "Insert 42 header"})

-- Telescope
keymap('n', '<leader><leader>', tlscpbuiltin.find_files, { desc = 'Telescope find files' })
keymap('n', '<leader>fg', tlscpbuiltin.live_grep, { desc = 'Telescope live grep' })
keymap('n', '<leader>fb', tlscpbuiltin.buffers, { desc = 'Telescope buffers' })
keymap('n', '<leader>fh', tlscpbuiltin.help_tags, { desc = 'Telescope help tags' })

