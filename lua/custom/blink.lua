pack_add({
	"rafamadriz/friendly-snippets",
	"L3MON4D3/LuaSnip",
	"saghen/blink.cmp",
	"https://github.com/saghen/blink.lib",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

require("luasnip.loaders.from_vscode").lazy_load()

local blink = require("blink.cmp")

blink.setup({
	snippets = {
		preset = "luasnip",
	},
	sources = {
		default = { "lsp", "buffer", "snippets", "path" },
	},
	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},
	fuzzy = {
		implementation = "lua",
		--		implementation = "prefer_rust_with_warning",
		sorts = {
			"exact",
			"score",
			-- This is the normal default order, which we fall back to
			"kind",
			"label",
		},
	},
	completion = {
		documentation = {
			auto_show = true,
		},
		ghost_text = {
			enabled = true,
		},
		list = {
			selection = {
				preselect = false,
				auto_insert = false,
			},
		},
	},
	signature = {
		enabled = true,
		trigger = {
			show_on_insert = true,
		},
	},
	keymap = {
		["<CR>"] = { "accept", "fallback" },
	},
})

vim.lsp.config("*", {
	capabilities = blink.get_lsp_capabilities(),
})
