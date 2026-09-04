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

require("help").add(
	"project/normal-mode",
	[[
Key 	Description
d 	delete currently selected project
r 	rename currently selected project
c 	create a project*
s 	search inside files within your project
b 	browse inside files within your project
w 	change to the selected project's directory without opening it
R 	find a recently opened file within your project
f 	find a file within your project (same as <CR>)
o 	change current cd scope
]]
)
require("help").add(
	"project/insert-mode",
	[[
Key 	Description
<c-d> 	delete currently selected project
<c-v> 	rename currently selected project
<c-a> 	create a project*
<c-s> 	search inside files within your project
<c-b> 	browse inside files within your project
<c-l> 	change to the selected project's directory without opening it
<c-r> 	find a recently opened file within your project
<c-f> 	find a file within your project (same as <CR>)
<c-o> 	change current cd scope
]]
)
