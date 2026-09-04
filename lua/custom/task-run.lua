pack_add({
	"zzejone/task-runner.nvim",
})
nvim.key.group("<leader>t", "task")
nvim.key.map("n", "<leader>tl", "<Cmd>TaskRun<CR>", { desc = "task-runner", silent = true })
