pack_add({
	"nvim-telescope/telescope-project.nvim",
})

require("telescope").load_extension("project")

require("telescope").setup({
	extensions = {
		project = {
			base_dirs = {
				"~/workspace",
				"~/workspace/sa",
			},
		},
	},
})

nvim.key.map("n", "<leader>p", function()
	require("telescope").extensions.project.project({})
end, { desc = "项目" })
