pack_add({
	"windwp/nvim-autopairs",
})

-- 导入 nvim-autopairs 插件
local npairs = require("nvim-autopairs")
-- 导入 Rule 类用于自定义规则
local Rule = require("nvim-autopairs.rule")

npairs.setup({
	-- 启用树 - sitter（Tree-sitter）语法检查。树 - sitter 是一个用于构建高效语法解析器的工具，开启此选项后，插件会利用树 - sitter 的语法信息来更智能地处理配对符号，避免在一些特定语法结构中错误地插入配对符号，例如在代码注释、字符串字面量等内部不会自动配对。
	check_ts = true,
	-- 树-sitter的上下文检查
	ts_config = {
		go = { "string" }, -- 不检查 Go 语言字符串中的配对
	},
	-- 快速跳出配对符号
	fast_wrap = {},
})

-- 自定义规则：在 ` 包裹的字符串内允许双引号自动配对
npairs.add_rules({
	Rule('"', '"', "go"):with_pair(function(opts)
		local line = opts.line
		local col = opts.col
		local before = line:sub(1, col - 1)
		local backtick_count = select(2, before:gsub("`", ""))
		return backtick_count % 2 == 1
	end),
})
