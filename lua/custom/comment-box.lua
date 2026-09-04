pack_add({
	"LudoPinelli/comment-box.nvim",
})

require("comment-box").setup({
	comment_style = "auto",
	outer_blank_lines_above = true,
})

nvim.key.group("<leader>cb", "注释块")

nvim.key.map({ "n", "v" }, "<leader>cbb", "<cmd>CBllbox10<cr>", { desc = "comment box block" })
nvim.key.map("n", "<leader>cbt", "<cmd>CBllline6<cr>", { desc = "comment box title" })
nvim.key.map("n", "<leader>cbj", "<cmd>CBllline6<cr>dd0i//<esc>jdd", { desc = "注释后删除上下两行" })
nvim.key.map("n", "<leader>cbc", "<cmd>CBcatalog<cr>", { desc = "comment box category" })
