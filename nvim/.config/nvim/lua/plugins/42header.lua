return {
  "Diogo-ss/42-header.nvim",
  cmd = { "Stdheader" },
  opts = {
    default_map = true, -- Default mapping <F1> in normal mode.
    auto_update = true, -- Update header when saving.
    user = "abetemps", -- Your user.
    mail = "abetemps@student.42lyon.fr", -- Your mail.
    -- add other options.
  },
  config = function(_, opts)
    require("42header").setup(opts)
  end,
}
