-- 检查是否是 Go 文件
local function is_go_file()
	return vim.bo.filetype == "go"
end

-- 定义函数：执行 go mod tidy 并重启 LSP
local function go_tidy_and_restart()
	-- 保存当前文件（可选）
	vim.cmd("w")

	-- 执行 go mod tidy（同步阻塞执行，确保完成后才重启 LSP）
	print("go mod tidy 命令执行完毕:", vim.fn.system("go mod tidy"))

	-- 重启 LSP 客户端（如 gopls）
	vim.schedule(function()
		vim.cmd("LspRestart")
	end)
end

-- 创建自定义transform选择器
local function go_tag_transform_picker()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local options = {
		{ value = "snakecase", label = "snakecase: userName → user_name" },
		{ value = "camelcase", label = "camelcase: user_name → userName" },
		{ value = "lispcase", label = "lispcase: UserName → user-name" },
		{ value = "pascalcase", label = "pascalcase: user_name → UserName" },
		{ value = "titlecase", label = "titlecase: user_name → User Name" },
		{ value = "keep", label = "keep: 保持原样" },
	}
	pickers
		.new({}, {
			prompt_title = "Go Tag Transform",
			finder = finders.new_table({
				results = options,
				entry_maker = function(entry)
					return { value = entry.value, display = entry.label, ordinal = entry.label }
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				local function select()
					local selection = action_state.get_selected_entry()
					if not selection then
						return
					end
					actions.close(prompt_bufnr)
					vim.cmd("GoAddTag json -transform " .. selection.value .. " -override")
				end
				map("i", "<CR>", select)
				map("n", "<CR>", select)
				return true
			end,
		})
		:find()
end

pack_add({
	"ray-x/guihua.lua",
	"neovim/nvim-lspconfig",
	"nvim-treesitter/nvim-treesitter",
	"ray-x/go.nvim",
})

require("go").setup({
	disable_defaults = false, -- true|false when true set false to all boolean settings and replace all tables
	remap_commands = {}, -- Vim commands to remap or disable, e.g. `{ GoFmt = "GoFormat", GoDoc = false }`
	-- settings with {}; string will be set to ''. user need to setup ALL the settings
	-- It is import to set ALL values in your own config if set value to true otherwise the plugin may not work
	go = "go", -- go command, can be go[default] or e.g. go1.18beta1
	goimports = "gopls", -- goimports command, can be gopls[default] or either goimports or golines if need to split long lines
	gofmt = "gopls", -- gofmt through gopls: alternative is gofumpt, goimports, golines, gofmt, etc
	fillstruct = "gopls", -- set to fillstruct if gopls fails to fill struct
	max_line_len = 0, -- max line length in golines format, Target maximum line length for golines
	tag_transform = false, -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
	tag_options = "json=omitempty", -- sets options sent to gomodifytags, i.e., json=omitempty
	gotests_template = "", -- sets gotests -template parameter (check gotests for details)
	gotests_template_dir = "", -- sets gotests -template_dir parameter (check gotests for details)
	gotest_case_exact_match = true, -- true: run test with ^Testname$, false: run test with TestName
	comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. 󰟓       
	icons = { breakpoint = "🧘", currentpos = "🏃" }, -- setup to `false` to disable icons setup
	verbose = false, -- output loginf in messages
	lsp_semantic_highlights = false, -- use highlights from gopls, disable by default as gopls/nvim not compatible
	lsp_cfg = {}, -- true: use non-default gopls setup specified in go/lsp.lua
	-- false: do nothing
	-- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
	-- lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
	lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
	-- false: do not set default gofmt in gopls format to gofumpt
	lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua,
	--      when lsp_cfg is true
	-- if lsp_on_attach is a function: use this function as on_attach function for gopls
	lsp_keymaps = true, -- set to false to disable gopls/lsp keymap
	lsp_codelens = false, -- true: use on_attach in go/lsp.lua, false: disable (vim.lsp.codelens.enable removed in Neovim 0.11)
	-- function(bufnr)
	--    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap=true, silent=true})
	-- end
	-- to setup a table of codelens

	golangci_lint = {
		default = "standard", -- set to one of { 'standard', 'fast', 'all', 'none' }
		disable = {}, -- linters to disable empty by default
		enable = { "govet", "ineffassign", "revive" }, -- linters to enable; empty by default
		config = nil, -- set to a config file path
		no_config = false, -- true: golangci-lint --no-config
		-- disable = {},     -- linters to disable empty by default, e.g. {'errcheck', 'staticcheck'}
		-- enable = {},      -- linters to enable; empty by default, set to e.g. {'govet', 'ineffassign','revive', 'gosimple'}
		-- enable_only = {}, -- linters to enable only; empty by default, set to e.g. {'govet', 'ineffassign','revive', 'gosimple'}
		severity = vim.diagnostic.severity.INFO, -- severity level of the diagnostics
	},
	null_ls = { -- check null-ls integration in readme
		golangci_lint = {
			method = { "NULL_LS_DIAGNOSTICS_ON_SAVE", "NULL_LS_DIAGNOSTICS_ON_OPEN" }, -- when it should run
			severity = vim.diagnostic.severity.WARN, -- severity level of the diagnostics
		},
		gotest = {
			method = { "NULL_LS_DIAGNOSTICS_ON_SAVE" }, -- when it should run
			severity = vim.diagnostic.severity.WARN, -- severity level of the diagnostics
		},
	},
	diagnostic = { -- set diagnostic to false to disable vim.diagnostic.config setup,
		-- true: default nvim setup
		hdlr = false, -- hook lsp diag handler and send diag to quickfix
		underline = false,
		virtual_text = false, -- virtual text setup
	},
	-- if you need to setup your ui for input and select, you can do it here
	-- go_input = require('guihua.input').input -- set to vim.ui.input to disable guihua input
	-- go_select = require('guihua.select').select -- vim.ui.select to disable guihua select
	lsp_document_formatting = true,
	-- set to true: use gopls to format
	-- false if you want to use other formatter tool(e.g. efm, nulls)
	lsp_inlay_hints = {
		enable = true, -- this is the only field apply to neovim > 0.10
	},
	gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
	gopls_remote_auto = true, -- add -remote=auto to gopls
	gocoverage_sign = "█",
	sign_priority = 5, -- change to a higher number to override other signs
	dap_debug = true, -- set to false to disable dap
	dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
	-- false: do not use keymap in go/dap.lua.  you must define your own.
	-- Windows: Use Visual Studio keymap
	dap_debug_gui = {}, -- bool|table put your dap-ui setup here set to false to disable
	dap_debug_vt = { enabled = true, enabled_commands = true, all_frames = true }, -- bool|table put your dap-virtual-text setup here set to false to disable

	dap_port = 38697, -- can be set to a number, if set to -1 go.nvim will pick up a random port
	dap_timeout = 15, --  see dap option initialize_timeout_sec = 15,
	dap_retries = 20, -- see dap option max_retries
	dap_enrich_config = nil, -- see dap option enrich_config
	build_tags = "tag1,tag2", -- set default build tags
	textobjects = true, -- enable default text objects through treesittter-text-objects
	test_runner = "go", -- one of {`go`,  `dlv`, `ginkgo`, `gotestsum`}
	verbose_tests = true, -- set to add verbose flag to tests deprecated, see '-v' option
	run_in_floaterm = false, -- set to true to run in a float window. :GoTermClose closes the floatterm
	-- float term recommend if you use gotestsum ginkgo with terminal color

	floaterm = { -- position
		posititon = "auto", -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
		width = 0.45, -- width of float window if not auto
		height = 0.98, -- height of float window if not auto
		title_colors = "nord", -- default to nord, one of {'nord', 'tokyo', 'dracula', 'rainbow', 'solarized ', 'monokai'}
		-- can also set to a list of colors to define colors to choose from
		-- e.g {'#D8DEE9', '#5E81AC', '#88C0D0', '#EBCB8B', '#A3BE8C', '#B48EAD'}
	},
	trouble = false, -- true: use trouble to open quickfix
	test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
	luasnip = false, -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
	--  Do not enable this if you already added the path, that will duplicate the entries
	on_jobstart = function(cmd)
		_ = cmd
	end, -- callback for stdout
	on_stdout = function(err, data)
		_, _ = err, data
	end, -- callback when job started
	on_stderr = function(err, data)
		_, _ = err, data
	end, -- callback for stderr
	on_exit = function(code, signal, output)
		_, _, _ = code, signal, output
	end, -- callback for jobexit, output : string
	iferr_vertical_shift = 4, -- defines where the cursor will end up vertically from the begining of if err statement
	iferr_less_highlight = false, -- set to true to make 'if err != nil' statements less highlighted (grayed out)
})

nvim.key.group("<leader>lg", "go")

nvim.key.map("n", "<leader>lgta", "<cmd>GoAddTags<cr>", { desc = "添加tag" })

nvim.key.map("n", "<leader>lga", "<cmd>FieldAlignmentFix<cr>", { desc = "内存对齐修复" })
nvim.key.map("n", "<leader>lgc", "<cmd>GoCmt<cr>", { desc = "添加文档" })
nvim.key.map("n", "<leader>lgd", "<cmd>GoDoc<cr>", { desc = "显示文档" })
nvim.key.map("n", "<leader>lgtr", "<cmd>GoRmTag<cr>", { desc = "删除tag" })
nvim.key.map("n", "<leader>lgfs", "<cmd>GoFillStruct<cr>", { desc = "填充struct" })
nvim.key.map("n", "<leader>lgfw", "<cmd>GoFillSwitch<cr>", { desc = "填充switch" })
nvim.key.map("n", "<leader>lgfi", "<cmd>GoImpl<cr>", { desc = "填充interface" })
nvim.key.map("n", "<leader>lgfe", "<cmd>GoIfErr<cr>", { desc = "填充err" })
nvim.key.map("n", "<leader>lgfr", "<cmd>GoGenReturn<cr>", { desc = "填充return" })
nvim.key.map("n", "<leader>lgg", "<cmd>GoGet<cr>", { desc = "get" })
nvim.key.map("n", "<leader>lgl", "<cmd>GoLint<cr>", { desc = "lint" })
nvim.key.map("n", "<leader>lgv", "<cmd>GoVet<cr>", { desc = "显示隐藏错误" })
nvim.key.map("n", "<leader>lge", "<cmd>GoAddExpTest<cr>", { desc = "生成测试文件" })
nvim.key.map("n", "<leader>lgh", "<esc>:GoDoc ", { desc = "帮助文档" })
nvim.key.map("n", "<leader>lgm", "<cmd>GoModTidy<cr>", { desc = "go mod tidy" })
nvim.key.map("n", "<leader>lgi", go_tidy_and_restart, { desc = "go tidy + restart lsp" })
nvim.key.map("n", "<leader>lgtc", go_tag_transform_picker, { desc = "转换tag" })
nvim.key.map("n", "<leader>lgta", "<cmd>GoAddTag -transform pascalcase<cr>", { desc = "添加tag" })
