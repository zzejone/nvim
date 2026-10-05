pack_add("chrisgrieser/nvim-scissors")

require("scissors").setup({
	snippetDir = vim.fn.stdpath("config") .. "/snippets",
})

nvim.key.group("<leader>sp", "snippet handle")

nvim.key.map("n", "<leader>spe", function()
	require("scissors").editSnippet()
end, { desc = "Snippet: Edit" })

nvim.key.map(
	{ "n", "x" }, -- when used in visual mode, prefills the selection as snippet body
	"<leader>spa",
	function()
		require("scissors").addNewSnippet()
	end,
	{ desc = "Snippet: Add" }
)
