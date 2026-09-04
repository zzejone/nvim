local loader = require("utils.loader")

local servers = loader.load_modules("base.lsp")

vim.lsp.enable(servers)
