vim.lsp.config("vue_ls", {
	cmd = {
		"vue-language-server",
		"--stdio",
	},

	filetypes = {
		"vue",
	},

	root_markers = {
		"package.json",
		"vue.config.js",
		"vite.config.js",
		".git",
	},
})
