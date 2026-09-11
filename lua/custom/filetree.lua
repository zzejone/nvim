pack_add({
	"nvim-tree/nvim-tree.lua",
	"mikavilpas/yazi.nvim",
})

require("nvim-tree").setup()

vim.g.loaded_netrwPlugin = 1
require("yazi").setup({
	open_for_directories = true,
})

nvim.key.map("n", "<leader>wn", "<cmd>Yazi cwd<cr>", { desc = "文件树" })
