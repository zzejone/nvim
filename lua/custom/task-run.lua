pack_add({
	"zzjone/task-runner.nvim",
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
	"EthanJWright/vs-tasks.nvim",
})

nvim.key.group("<leader>t", "task")
require("telescope").load_extension("vstask")

require("vstask").setup({
	cache_json_conf = false,
	ignore_input_default = true,
	config_dir = ".vscode",
	terminal = "nvim",

	term_opts = {
		current = {
			direction = "float",
		},
		vertical = {
			direction = "vertical",
			size = 80,
		},
		horizontal = {
			direction = "horizontal",
			size = 10,
		},
		tab = {
			direction = "tab",
		},
	},
})

-- ============================================================
-- 获取 nvim 启动时的根目录
-- ============================================================

local function get_project_root()
	return vim.uv.cwd()
end

-- ============================================================
-- 查找 Taskfile.yml
-- ============================================================

local function find_taskfile()
	local path = vim.fs.joinpath(get_project_root(), "Taskfile.yml")

	if vim.uv.fs_stat(path) then
		return path
	end

	return nil
end

-- ============================================================
-- 查找 .vscode/tasks.json
-- ============================================================

local function find_vscode_tasks()
	local path = vim.fs.joinpath(get_project_root(), ".vscode/tasks.json")

	if vim.uv.fs_stat(path) then
		return path
	end

	return nil
end

-- ============================================================
-- 执行 Task
-- ============================================================

local function run_task()
	-- ----------------------------------------------------------
	-- Taskfile.yml
	-- ----------------------------------------------------------

	local taskfile = find_taskfile()

	if taskfile then
		vim.notify("Using Taskfile: " .. taskfile, vim.log.levels.INFO)

		vim.cmd("TaskRun")
		return
	end

	-- ----------------------------------------------------------
	-- .vscode/tasks.json
	-- ----------------------------------------------------------

	local vstaskfile = find_vscode_tasks()

	if vstaskfile then
		vim.notify("Using VS Code tasks: " .. vstaskfile, vim.log.levels.INFO)

		require("telescope").extensions.vstask.clear_inputs()
		require("vstask").tasks()
		return
	end

	-- ----------------------------------------------------------
	-- 没有找到
	-- ----------------------------------------------------------

	vim.notify(
		"No Taskfile.yml or .vscode/tasks.json found\n"
			.. "Current file: "
			.. vim.api.nvim_buf_get_name(0)
			.. "\nCurrent dir: "
			.. get_current_dir(),
		vim.log.levels.WARN
	)
end

-- ============================================================
-- Keymap
-- ============================================================

nvim.key.map("n", "<leader>tl", run_task, {
	desc = "Run project task",
	silent = true,
})
