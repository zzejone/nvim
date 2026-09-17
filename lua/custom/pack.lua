pack_add("igmrrf/pack.nvim")
vim.cmd.packadd("pack.nvim")

-- 3. Initialize pack.nvim with options and plugin specs
require("pack").setup({
	performance = {
		vim_loader = true, -- Fallback to ensure vim.loader.enable() is called if omitted
	},
	use_git = false, -- Clone/update via backgrounded `git` so the UI never blocks; native vim.pack still syncs the lockfile afterwards
	ui = {
		border = "rounded", -- Options: "single", "double", "rounded", "solid", "shadow"
		auto_open = true, -- Automatically open dashboard float after the first plugin install completes
		silent = nil, -- Silences native vim.pack cmdline messages (defaults to auto_open setting)
		filter = "default", -- Options: "default" (vim.ui.input), "input" (vim.fn.input), or fun(opts, cb)
		icons = {
			loaded = "●",
			not_loaded = "○",
			error = "✖",
			sync = "↺",
			queued = "◌",
		},
	},
})

nvim.key.map("n", "<leader>xp", "<cmd>Pack<cr>", { desc = "插件管理" })
