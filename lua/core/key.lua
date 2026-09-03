local M = {}

local groups = {}
local specs = {}

local handler = nil

--------------------------------------------------
-- 注册 group
--------------------------------------------------

function M.group(key, name, opts)
	opts = opts or {}

	local mode = opts.mode or "n"
	local id = key .. mode

	if groups[id] then
		if not vim.tbl_contains(groups[id].names, name) then
			table.insert(groups[id].names, name)
		end
	else
		groups[id] = {
			key = key,
			names = { name },
			mode = mode,
		}
	end
end

--------------------------------------------------
-- 注册快捷键
--------------------------------------------------

function M.map(mode, lhs, rhs, opts)
	opts = opts or {}

	vim.keymap.set(mode, lhs, rhs, opts)

	if opts.desc then
		table.insert(specs, {
			lhs = lhs,
			desc = opts.desc,
			mode = mode,
		})
	end
end

--------------------------------------------------
-- 生成 spec
--------------------------------------------------

function M.get_spec()
	local result = {}

	for _, item in pairs(groups) do
		table.insert(result, {
			item.key,
			group = table.concat(item.names, "/"),
			mode = item.mode,
		})
	end

	for _, item in ipairs(specs) do
		table.insert(result, {
			item.lhs,
			desc = item.desc,
			mode = item.mode,
		})
	end

	return result
end

--------------------------------------------------
-- 注入适配器
--------------------------------------------------

function M.setup(adapter)
	handler = adapter

	handler(M.get_spec())
end

return M
