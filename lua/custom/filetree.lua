pack_add({
	"nvim-tree/nvim-tree.lua",
})

require("nvim-tree").setup()

nvim.key.map("n", "<leader>wn", "<cmd>NvimTreeToggle<cr>", { desc = "文件树" })
