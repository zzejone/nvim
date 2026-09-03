local M = {}

local groups = {}
local specs = {}

local handler = nil

--------------------------------------------------
-- 注册 group
--------------------------------------------------

function M.group(key, name, opts)
    key = vim.trim(key)
    name = vim.trim(name)

    assert(key ~= "", "key_group: key cannot be empty")
    assert(name ~= "", "key_group: name cannot be empty")

    opts = opts or {}
    local mode = opts.mode or "n"
    local id = key .. mode

    if not groups[id] then
        groups[id] = {
            key = key,
            names = {},
            mode = mode,
        }
    end

    if not vim.tbl_contains(groups[id].names, name) then
        table.insert(groups[id].names, name)
    end
end

--------------------------------------------------
-- 注册快捷键
--------------------------------------------------

function M.map(mode, lhs, rhs, opts)
    lhs = vim.trim(lhs)
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
