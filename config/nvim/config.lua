vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('functions')
require('keymaps')

-- Navigation
require('navigation.telescope')
require('navigation.lastplace')

-- Code
require('code.package-manager')
require('code.treesitter')
require('code.lsp')
require('code.linters')
require('code.goto-preview')
require('code.docstring')
require('code.completion')

-- Appearance
require('appearance.theme')
require('appearance.animations')
require('appearance.starter').setup()
