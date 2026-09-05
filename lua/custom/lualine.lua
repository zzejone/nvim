pack_add({
	"nvim-lualine/lualine.nvim",
})

local function show_macro_recording()
	local recording_register = vim.fn.reg_recording()
	if recording_register == "" then
		return ""
	else
		return "󰑋 " .. recording_register
	end
end

local macro_recording = {
	show_macro_recording,
	color = { fg = "#333333", bg = "#ff0000" },
	separator = { left = "", right = "" },
	padding = 0,
}

require("lualine").setup({
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = {
			{
				"filename",
				file_status = true, -- Displays file status (readonly status, modified status)
				newfile_status = false, -- Display new file status (new file means no write after created)
				path = 1, -- 0: Just the filename
				-- 1: Relative path
				-- 2: Absolute path
				-- 3: Absolute path, with tilde as the home directory
				-- 4: Filename and parent dir, with tilde as the home directory

				shorting_target = 40, -- Shortens path to leave 40 spaces in the window
				-- for other components. (terrible name, any suggestions?)
				-- It can also be a function that returns
				-- the value of `shorting_target` dynamically.
				symbols = {
					modified = "[+]", -- Text to show when the file is modified.
					readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
					unnamed = "[未命名]", -- Text to show for unnamed buffers.
					newfile = "[新]", -- Text to show for newly created file before first write
				},
			},
			"progress",
			"location",
		},
		lualine_x = { "searchcount", "selectioncount", macro_recording },
		lualine_y = {
			{
				"diagnostics",
				sources = {
					"nvim_workspace_diagnostic",
				},
				sections = { "error", "warn", "info", "hint" },
				update_in_insert = true, -- Update diagnostics in insert mode.
				always_visible = false,
			},
		},
		lualine_z = { "filetype", "lsp_status" },
		-- lualine_z = { "encoding", "fileformat", "filetype", "lsp_status" },
	},
	options = {
		theme = "everforest",
		component_separators = { left = "/", right = "\\" },
		--                
		section_separators = { left = "", right = "" },
		always_divide_middle = true,
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = { { "location", padding = 0 } },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
})
