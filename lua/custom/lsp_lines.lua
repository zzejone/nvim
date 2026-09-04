pack_add({

	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
})

require("lsp_lines").setup()
vim.diagnostic.config({ virtual_lines = true })

nvim.key.map("n", "<leader>Tl", function()
	require("lsp_lines").toggle()
end, { desc = "Toggle lsp_lines" })
