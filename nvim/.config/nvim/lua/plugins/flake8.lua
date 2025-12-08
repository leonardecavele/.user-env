return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      python = { "flake8" },
    }

    local grp = vim.api.nvim_create_augroup("PythonLint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = grp,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
