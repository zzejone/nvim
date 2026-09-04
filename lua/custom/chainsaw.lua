pack_add({

	"chrisgrieser/nvim-chainsaw",
})

require("chainsaw").setup({
	logStatements = {
		variableLog = {
			javascript = 'console.info("{{marker}} {{lnum}} {{var}}:", {{var}});',
		},
		-- the same for the other log statement operations
	},
})

nvim.key.group("<leader>ll", "变量打印")
nvim.key.map("n", "<leader>llv", "<cmd>Chainsaw variableLog<cr>", { desc = "log variable" })
nvim.key.map("n", "<leader>llo", "<cmd>Chainsaw objectLog<cr>", { desc = "log objectLog" })
nvim.key.map("n", "<leader>llt", "<cmd>Chainsaw typeLog<cr>", { desc = "log type" })
nvim.key.map("n", "<leader>lla", "<cmd>Chainsaw assertLog<cr>", { desc = "log assert" })
nvim.key.map("n", "<leader>lle", "<cmd>Chainsaw emojiLog<cr>", { desc = "log emoji" })
nvim.key.map("n", "<leader>lls", "<cmd>Chainsaw soundLog<cr>", { desc = "log sound" })
nvim.key.map("n", "<leader>llm", "<cmd>Chainsaw messageLog<cr>", { desc = "log message" })
nvim.key.map("n", "<leader>llc", "<cmd>Chainsaw clearLog<cr>", { desc = "log clear" })
nvim.key.map({ "n", "v" }, "<leader>llr", "<cmd>Chainsaw removeLogs<cr>", { desc = "log remove" })
