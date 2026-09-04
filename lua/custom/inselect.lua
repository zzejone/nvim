pack_add({
	-- 扩大缩小选择
	"shushtain/incselect.nvim",
})

nvim.key.map("n", "<CR>", require("incselect").init)
nvim.key.map("x", "<CR>", require("incselect").parent)
nvim.key.map("x", "<S-CR>", require("incselect").child)
nvim.key.map("x", "<Tab>", require("incselect").next)
nvim.key.map("x", "<S-Tab>", require("incselect").prev)
nvim.key.map("x", "<M-CR>", require("incselect").undo)
