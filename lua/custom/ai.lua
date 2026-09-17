pack_add("goropikari/ollama-completion.nvim")

require("ollama-completion").setup({
	model = "qwen2.5-coder:3b",
})
