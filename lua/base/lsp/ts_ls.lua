vim.lsp.config("ts_ls", {
	filetypes = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"vue",
	},
	settings = {
		typescript = {
			-- 显式指定全局 TypeScript，避免 "Could not find a valid TypeScript installation"
			inlayHints = {
				includeInlayEnumMemberValueHints = false,
				includeInlayFunctionLikeReturnTypeHints = false,
				includeInlayFunctionParameterTypeHints = false,
				includeInlayParameterNameHints = "none", -- 'none' | 'literals' | 'all';
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayPropertyDeclarationTypeHints = false,
				includeInlayVariableTypeHints = false,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = false,
				includeInlayFunctionLikeReturnTypeHints = false,
				includeInlayFunctionParameterTypeHints = false,
				includeInlayParameterNameHints = "none", -- 'none' | 'literals' | 'all';
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayPropertyDeclarationTypeHints = false,
				includeInlayVariableTypeHints = false,
			},
		},
	},
})
