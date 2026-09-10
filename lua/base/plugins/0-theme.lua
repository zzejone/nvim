pack_add("catppuccin/nvim")

require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
})

vim.cmd("colorscheme catppuccin")
