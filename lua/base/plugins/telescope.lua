pack_add({
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",
	"nvim-telescope/telescope-fzf-native.nvim",
	"nvim-telescope/telescope.nvim",
})

local function cwd()
	return vim.fn.getcwd()
end
local function project_root()
	return vim.fs.root(0, { ".git", "go.mod", "package.json", "pnpm-workspace.yaml" }) or vim.fn.getcwd()
end

local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		prompt_prefix = "   ",
		selection_caret = "➜ ",

		path_display = {
			"smart",
		},

		sorting_strategy = "ascending",

		layout_strategy = "horizontal",

		layout_config = {
			horizontal = {
				preview_width = 0.55,
			},

			width = 0.95,
			height = 0.90,
		},

		file_ignore_patterns = {
			"node_modules",
			"%.git/",
			"dist/",
			"build/",
			"tmp/",
			"%.log$",
		},

		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,

				["<Esc>"] = actions.close,
			},

			n = {
				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,

				["q"] = actions.close,
			},
		},
	},

	pickers = {
		find_files = {
			hidden = true,
		},

		live_grep = {
			additional_args = function()
				return {
					"--hidden",
					"--glob",
					"!node_modules",
					"--glob",
					"!.git",
					"--glob",
					"!dist",
					"--glob",
					"!build",
				}
			end,
		},

		buffers = {
			sort_mru = true,
			ignore_current_buffer = true,
		},
	},

	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

nvim.key.group("<leader>s", "搜索")
nvim.key.group("<leader>f", "文件")
nvim.key.group("<leader>b", "buffer")
nvim.key.group("<leader>l", "language")
nvim.key.group("<leader>lp", "lsp")

nvim.key.map("n", "<leader>sf", function()
	require("telescope.builtin").find_files({ cwd = cwd(), hidden = true })
end, { desc = "搜索文件" })

nvim.key.map("n", "<leader>ss", function()
	require("telescope.builtin").live_grep({ cwd = cwd() })
end, { desc = "搜索文本" })

nvim.key.map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "最近打开" })
nvim.key.map("n", "<leader>bs", "<cmd>Telescope buffers<cr>", { desc = "buffer" })
nvim.key.map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "帮助" })
nvim.key.map("n", "<leader>lpd", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "lsp document symbols" })
nvim.key.map("n", "<leader>lpi", "<cmd>Telescope lsp_references<cr>", { desc = "lsp references" })
nvim.key.map("n", "<leader>ld", "<cmd>Telescope diagnostics<cr>", { desc = "diagnostics" })
nvim.key.map("n", "?", "<cmd>Telescope builtin<cr>", { desc = "telescope pickers" })
