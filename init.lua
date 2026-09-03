-- 快捷键注册
local key = require("core.key")
_G.nvim = {
	key = key,
}

-- 插件管理
local pack = require("core.1_pack")
_G.pack_add = pack.add

require("core")

require("base.plugins")
require("base.lsp")

require("custom")

require("base.post")
