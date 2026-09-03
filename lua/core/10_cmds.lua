-- core/03_commands.lua
vim.api.nvim_create_user_command("Reload", function()
	vim.cmd.source(vim.fn.stdpath("config") .. "/init.lua")
end, {})

-- 打开文件时定位到上次离开的位置
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	desc = "Neovim 退出前自动停止所有 LSP 客户端",
	callback = function()
		local clients = vim.lsp.get_clients()
		for _, client in ipairs(clients) do
			vim.lsp.stop_client(client.id, true) -- 第二个参数 true 表示强制关闭 (force)
		end
	end,
})
