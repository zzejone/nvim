local map = nvim.key.map

local function setDesc(desc)
	return {
		desc = desc,
		noremap = true,
		silent = false,
	}
end

nvim.key.group("<leader>w", "保存")
nvim.key.group("<leader>q", "退出")
map("n", "<Leader>we", "<cmd>wq!<cr>", setDesc("保存并强制退出"))
map("n", "<Leader>ww", "<cmd>w!<cr>", setDesc("强制保存"))
map("n", "<Leader>wW", "<cmd>w !sudo tee %  >/dev/null<cr>", setDesc("sudo保存"))

nvim.key.group("<leader>w", "窗口")
nvim.key.group("<leader>ws", "分割")
map("n", "<Leader>wsv", "<C-W>v", setDesc("左右分割"))
map("n", "<Leader>wsh", "<C-W>s", setDesc("上下分割"))

map("n", "<C-j>", "<C-w><C-j>", setDesc("切换到下边窗口"))
map("n", "<C-k>", "<C-w><C-k>", setDesc("切换到上面窗口"))
map("n", "<C-l>", "<C-w><C-l>", setDesc("切换到右边窗口"))
map("n", "<C-h>", "<C-w><C-h>", setDesc("切换到左边窗口"))

nvim.key.group("<leader>x", "工具")
map("n", "<leader>xR", "<cmd>Reload<cr>", setDesc("重载配置"))

-- ─[ 强制退出 ]───────────────────────────────────────────────────────
local quit_tracker = {
	last_time = 0,
	count = 0,
}

map("n", "<leader>qq", function()
	vim.defer_fn(function()
		vim.notify("退出")
	end, 111)
	local current_time = vim.uv.hrtime() / 1e9
	local time_diff = current_time - quit_tracker.last_time

	-- 重置计数如果超过2秒
	if time_diff > 2 then
		quit_tracker.count = 0
	end

	quit_tracker.count = quit_tracker.count + 1
	quit_tracker.last_time = current_time

	if quit_tracker.count >= 2 then
		-- 显示提示信息
		-- vim.notify("强制退出所有窗口!", vim.log.levels.WARN)
		quit_tracker.count = 0 -- 重置计数
		vim.cmd("qall")
	else
		-- 显示提示，告诉用户可以再次按来强制退出所有
		-- vim.notify("退出当前窗口，2秒内再按一次退出所有", vim.log.levels.INFO)
		-- 延迟执行退出，让用户看到提示
		vim.defer_fn(function()
			if quit_tracker.count > 0 then -- 如果没有再次触发
				vim.cmd("q")
			end
		end, 100)
	end
end, setDesc("强制退出")) -- 这里 silent=false 是为了显示消息

-- ─[ 复制当前文件路径到剪切板 ]───────────────────────────────────────
nvim.key.group("<leader>c", "复制")
map("n", "<leader>cP", function()
	local path = vim.fn.expand("%:p")
	if path == "" then
		return
	end
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, setDesc("复制文件路径"))

-- ─[ 复制内容到系统剪切板 ]───────────────────────────────────────────
-- 映射 Ctrl+y 在 Visual 模式下来复制到系统剪切板
map("v", "<C-y>", '"+y', setDesc("复制"))
