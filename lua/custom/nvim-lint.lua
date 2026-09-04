pack_add({
	"mfussenegger/nvim-lint",
})
local lint = require("lint")

-- 配置不同文件类型的代码检查工具
lint.linters_by_ft = {
	bash = { "bash" },
	html = { "htmlhint" },
	javascript = { "eslint" },
	python = { "pylint" },
	typescript = { "eslint" },
	vue = { "eslint" },
	proto = { "protolint" },
	go = { "golangcilint" },
}

-- 创建一个自动命令组
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

-- 定义自动命令，当缓冲区写入或进入缓冲区时触发代码检查
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
		-- lint.try_lint "cspell"
	end,
})
