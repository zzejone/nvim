pack_add({
	"stevearc/conform.nvim",
})

require("conform").setup({
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		go = { "goimports-reviser", "gofumpt", "golines" },
		log = { "jq_log_formatter" },
		lua = { "stylua" },
		html = { "prettier" },
		nix = { "alejandra" },
		python = { "isort", "black" },
		toml = { "taplo" },
		sh = { "shfmt" },
		proto = { "buf" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		yaml = { "prettier" },
		vue = { "prettier" },
		markdown = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		less = { "prettier" },
		-- Use the "*" filetype to run formatters on all filetypes.
		["*"] = {},
		-- Use the "_" filetype to run formatters on filetypes that don't
		-- have other formatters configured.
		["_"] = { "trim_whitespace" },
	},
	notify_on_error = true,
	-- Conform will notify you when no formatters are available for the buffer
	notify_no_formatters = true,
	-- Customize formatters
	formatters = {
		jq_log_formatter = {
			command = "jq",
			args = { "--indent", "4", "-R", "fromjson?" },
			stdin = true,
		},
		shfmt = {
			prepend_args = { "-i", "4", "-ci" }, -- 4 个空格缩进，case 缩进
		},
		prettier = {
			prepend_args = { "--trailing-comma", "es5" },
		},
		["goimports-reviser"] = {
			prepend_args = {
				"-rm-unused", -- 删除未使用的 import
				"-set-alias", -- 为带版本的包自动设置别名
				"-company-prefixes", -- 公司前缀（可选，比如你们公司的内网域名）
			},
		},
		golines = {
			prepend_args = { "--max-len=80" },
		},
	},
})

nvim.key.map("n", "<leader>lf", function()
	require("conform").format()
end, { desc = "格式化当前文档" })

nvim.key.group("<leader>T", "切换")
nvim.key.map("n", "<leader>Tf", function()
	if vim.b.disable_autoformat or vim.g.disable_autoformat then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = false
		vim.g.disable_autoformat = false
		vim.notify("disable auto format")
	else
		vim.b.disable_autoformat = true
		vim.g.disable_autoformat = true
		vim.notify("enable auto format")
	end
end, { desc = "切换自动格式化" })
