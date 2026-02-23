-- https://github.com/kkoomen/vim-doge

vim.api.nvim_create_user_command('DogeAll', function()
  if vim.fn.exists(':DogeGenerate') ~= 2 then
    vim.notify('vim-doge n’est pas chargé (commande :DogeGenerate introuvable)')
    return
  end

  vim.cmd([[silent! g/^\s*\(def\s\+\k\+\s*(\|class\s\+\k\+\)/DogeGenerate numpy]])

  vim.cmd([[silent! %s/\("""\)\[TODO:summary\]\n\(\s*\)/\1\2/ge]])
  vim.cmd([[silent! %s/\[TODO:description\]/[TODO:brief_description]/ge]])
end, {})

vim.keymap.set('n', ' x', '<Plug>(doge-generate)', { desc = 'Generate Docstring for current cursor position' })
