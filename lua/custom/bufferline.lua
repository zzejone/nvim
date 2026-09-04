pack_add({
	"akinsho/bufferline.nvim",
})

require("bufferline").setup({
	options = {
		separator_style = "thin",
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(_, _, diagnostics_dict, _)
			local s = " "
			for e, n in pairs(diagnostics_dict) do
				local sym = e == "error" and " " or (e == "warning" and " " or " ")
				s = s .. n .. sym
			end
			return s
		end,
	},
})

require("nvim-web-devicons").setup({
	override = {
		typ = { icon = "󰰥", color = "#239dad", name = "typst" },
	},
})
