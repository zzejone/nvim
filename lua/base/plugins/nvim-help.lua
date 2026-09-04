pack_add({
	"zzejone/nvim-help",
	"MeanderingProgrammer/render-markdown.nvim",
})
require("help").setup()

nvim.key.map("n", "<leader>hh", "<cmd>Help<cr>", { desc = "帮助" })
