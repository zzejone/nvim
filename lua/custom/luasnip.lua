pack_add({
	"rafamadriz/friendly-snippets",
	"L3MON4D3/LuaSnip",
})
require("luasnip.loaders.from_vscode").lazy_load({
	paths = {
		vim.fn.stdpath("config") .. "/snippets",
	},
})
