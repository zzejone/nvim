-- 代码大纲
pack_add({
	"nvim-treesitter/nvim-treesitter",
	"nvim-tree/nvim-web-devicons",
	"stevearc/aerial.nvim",
})

nvim.key.group("<leader>w", "大纲")
nvim.key.map("n", "<leader>wo", "<cmd>AerialNavToggle<CR>", { desc = "代码大纲" })
