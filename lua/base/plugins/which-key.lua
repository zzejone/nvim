vim.pack.add({
	{
		src = "https://github.com/folke/which-key.nvim",
	},
})

require("which-key").setup({
	delay = 10,

	icons = {
		mappings = vim.g.have_nerd_font,
	},

	spec = {
		{ "<leader>q", group = "退出" },
		{ "<leader>w", group = "保存/窗口" },
		{ "<leader>c", group = "复制" },
		{ "<leader>x", group = "工具" },
	},

	defaults = {
		mode = { "n", "v" },
	},

	preset = "helix",
})
