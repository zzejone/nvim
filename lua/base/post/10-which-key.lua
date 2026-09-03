pack_add("folke/which-key.nvim")

require("which-key").setup({
	delay = 10,

	icons = {
		mappings = vim.g.have_nerd_font,
	},

	preset = "helix",
})

local key = nvim.key
key.setup(function(spec)
	require("which-key").add(spec)
end)
