pack_add({
	"nvim-treesitter/nvim-treesitter",
})

local pkgs = {
	"astro",

	"bash",

	"dockerfile",

	"git_rebase",
	"gitcommit",
	"gitignore",

	"go",
	"goctl",
	"gomod",
	"gosum",
	"gowork",

	"lua",

	"markdown",
	"markdown_inline",

	"rust",

	"css",
	"scss",
	"vue",
	"typescript",
	"html",
	"javascript",
	"tsx",

	"vim",
	"vimdoc",

	"query",

	"toml",
	"yaml",
	"json",
}
require("nvim-treesitter").setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
	highlight = {
		enable = true,
		disable = function(_, buf)
			local max_filesize = 200 * 1024 -- 200KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
})

require("nvim-treesitter").install(pkgs)
