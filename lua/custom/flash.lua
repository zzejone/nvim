pack_add({
	-- 快速跳转到任意位置
	"folke/flash.nvim",
})

require("flash").setup()

nvim.key.map({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })

nvim.key.map({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })

require("help").add(
	"跳转",
	[[
s buffer内快速跳转
S treesitter快速跳转
]]
)
