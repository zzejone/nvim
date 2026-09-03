pack_add("folke/tokyonight.nvim")

require("tokyonight").setup({
	style = "day", -- Dynamically set based on selected_theme
	transparent = false,
	terminal_colors = true,
	styles = {
		comments = { italic = true },
		keywords = { italic = true },
		functions = {},
		variables = {},
	},
})

vim.cmd("colorscheme tokyonight-night")
