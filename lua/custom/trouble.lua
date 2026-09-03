pack_add({
	"folke/trouble.nvim",
})

require("trouble").setup({})

nvim.key.group("<leader>x", "诊断")
nvim.key.map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle <cr>", { desc = "诊断" })
nvim.key.map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "诊断列表" })
nvim.key.map(
	"n",
	"<leader>xe",
	"<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR filter.buf=0 win.position=right<cr>",
	{ desc = "当前文件诊断" }
)
nvim.key.map(
	"n",
	"<leader>xa",
	"<cmd>Trouble diagnostics toggle filter.buf=0 win.position=right<cr>",
	{ desc = "项目诊断" }
)
