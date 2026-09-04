pack_add({
	"windwp/nvim-spectre",
})
require("spectre").setup({
	open_cmd = "vnew", -- can also be a lua function
	live_update = true, -- auto execute search again when you write to any file in vim
	lnum_for_results = true, -- show line number for search/replace results
	mapping = {
		["run_current_replace"] = {
			map = "<leader><leader>",
			cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
			desc = "替换当前行",
		},
	},
})

nvim.key.group("<leader>s", "替换")
nvim.key.map("n", "<leader>sr", function()
	require("spectre").toggle()
end, { desc = "全局搜索替换" })
