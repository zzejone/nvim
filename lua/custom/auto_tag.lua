pack_add({
	"nvim-treesitter/nvim-treesitter",
	"windwp/nvim-ts-autotag",
})

require("nvim-ts-autotag").setup({
	filetypes = {
		"html",
		"vue",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
})
