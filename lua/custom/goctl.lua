pack_add({
	"fahmiauliarahman/goctl.nvim",
})

require("goctl").setup({
	format_on_save = true,
	goctl_path = "goctl",
	enable_snippets = true,
	enable_keymaps = true,
	remove_struct_keyword = true,
})
