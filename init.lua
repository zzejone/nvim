local key = require("core.key")
_G.nvim = {
	key = key,
}

require("core")

require("base.plugins")
require("base.lsp")

require("custom")
