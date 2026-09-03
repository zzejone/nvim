local M = {}

local PREFIX = "https://github.com/"

local function normalize(src)
	-- 已经是完整 URL
	if src:match("^https?://") then
		return src
	end

	-- github 用户/仓库
	return PREFIX .. src
end

function M.add(plugins)
	if type(plugins) == "string" then
		plugins = { plugins }
	end

	assert(type(plugins) == "table", "pack_add: expected string or table")

	local specs = {}

	for _, plugin in ipairs(plugins) do
		if type(plugin) == "string" then
			table.insert(specs, {
				src = normalize(plugin),
			})
		elseif type(plugin) == "table" then
			-- 如果以后需要支持 name / version / hooks 等 vim.pack 参数
			local spec = vim.deepcopy(plugin)

			if spec.src then
				spec.src = normalize(spec.src)
			end

			table.insert(specs, spec)
		else
			error("pack_add: invalid plugin spec")
		end
	end

	vim.pack.add(specs)
end

return M
