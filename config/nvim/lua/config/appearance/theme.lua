-- https://github.com/catppuccin/nvim
local catppuccin_ok, catppuccin = pcall(require, "catppuccin")
if catppuccin_ok then
    vim.o.background = "light"

    catppuccin.setup({
        flavour = "auto", -- latte, frappe, macchiato, mocha, auto
        background = {
            light = "latte",
        },
        transparent_background = true,
    })

    vim.cmd("colorscheme catppuccin")
end

-- https://github.com/xiyaowong/transparent.nvim
local transparent_ok, transparent = pcall(require, "transparent")
if transparent_ok then
    transparent.setup({
        groups = {
            'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
            'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
            'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
            'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
            'EndOfBuffer',
        },
        extra_groups = {
            "NormalFloat", "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeNormalFloat",
            "NvimTreeEndOfBuffer", "StatusLine", "StatusLineNC", "BufferLineTabClose",
            "BufferlineBufferSelected", "BufferLineFill", "BufferLineBackground",
            "BufferLineSeparator", "BufferLineIndicatorSelected", "IndentBlanklineChar",
            "ToggleTerm", "LspFloatWinNormal", "Normal", "FloatBorder", "TermNormal",
            "TelescopeNormal", "TelescopeBorder", "TelescopePromptBorder",
        }
    })

	vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", {
	  fg = "#352d36",
	  bg = "NONE"
	})

	keymap("n", " tt", "<cmd>TransparentToggle<cr>", { desc = "Toogle Nvim Transparency" })

	vim.api.nvim_set_hl(0, "ColorColumn", {
	  bg = "#fc8181"
	})
end
