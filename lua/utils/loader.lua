local M = {}

-- 自动加载指定模块目录下的所有 lua 文件
-- path:
--   模块路径，例如 "core"
--   "base.lsp"
function M.load_modules(path)
	local dir = vim.fn.stdpath("config") .. "/lua/" .. path:gsub("%.", "/")

	local files = {}

	for file, type in vim.fs.dir(dir) do
		if type == "file" and file:match("%.lua$") and file ~= "init.lua" then
			table.insert(files, file)
		end
	end

	table.sort(files)

	local modules = {}

	for _, file in ipairs(files) do
		local module = file:gsub("%.lua$", "")

		require(path .. "." .. module)

		table.insert(modules, module)
	end

	return modules
end

return M
