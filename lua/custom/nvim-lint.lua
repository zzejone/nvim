pack_add({
	"mfussenegger/nvim-lint",
})
local lint = require("lint")

-- eslint 未安装时的处理：跳过对应语言的 lint，避免 ENOENT 报错
local eslint_found = vim.fn.executable("eslint") == 1

lint.linters_by_ft = {
	bash = { "bash" },
	html = { "htmlhint" },
	javascript = eslint_found and { "eslint" } or {},
	python = { "pylint" },
	typescript = eslint_found and { "eslint" } or {},
	vue = eslint_found and { "eslint" } or {},
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
