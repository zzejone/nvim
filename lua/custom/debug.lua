pack_add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
	"https://github.com/leoluz/nvim-dap-go",
})

require("help").add(
	"debug",
	[[
F1      step info
f5      start / continue
f7      see last session result
F8      step over
f9      step out
]]
)

nvim.key.group("<leader>d", "debug")
-- Basic debugging keymaps, feel free to change to your liking!
nvim.key.map("n", "<F5>", function()
	require("dap").continue()
end, { desc = "Debug: Start/Continue" })
nvim.key.map("n", "<F1>", function()
	require("dap").step_into()
end, { desc = "Debug: Step Into" })
nvim.key.map("n", "<F8>", function()
	require("dap").step_over()
end, { desc = "Debug: Step Over" })
nvim.key.map("n", "<F9>", function()
	require("dap").step_out()
end, { desc = "Debug: Step Out" })
nvim.key.map("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })
nvim.key.map("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Set Breakpoint" })
nvim.key.map("n", "<F7>", function()
	require("dapui").toggle()
end, { desc = "Debug: See last session result." })

local dap = require("dap")
local dapui = require("dapui")

require("mason-nvim-dap").setup({
	-- Makes a best effort to setup the various debuggers with
	-- reasonable debug configurations
	automatic_installation = true,

	-- You can provide additional configuration to the handlers,
	-- see mason-nvim-dap README for more information
	handlers = {},

	-- You'll need to check that you have the required things installed
	-- online, please don't ask me how to install them :)
	ensure_installed = {
		-- Update this to ensure that you have the debuggers for the langs you want
		"delve",
	},
})

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
---@diagnostic disable-next-line: missing-fields
dapui.setup({
	-- Set icons to characters that are more likely to work in every terminal.
	--    Feel free to remove or use ones that you like more! :)
	--    Don't feel like these are good choices.
	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
	---@diagnostic disable-next-line: missing-fields
	controls = {
		icons = {
			pause = "⏸",
			play = "▶",
			step_into = "⏎",
			step_over = "⏭",
			step_out = "⏮",
			step_back = "b",
			run_last = "▶▶",
			terminate = "⏹",
			disconnect = "⏏",
		},
	},
})

-- Change breakpoint icons
-- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
-- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
-- local breakpoint_icons = vim.g.have_nerd_font
--     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
--   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
-- for type, icon in pairs(breakpoint_icons) do
--   local tp = 'Dap' .. type
--   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
--   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
-- end

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

-- Install golang specific config
require("dap-go").setup({
	delve = {
		-- On Windows delve must be run attached or it crashes.
		-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
		detached = vim.fn.has("win32") == 0,
	},
})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define(
	"DapBreakpointRejected",
	{ text = "󰃤", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
)
vim.fn.sign_define("DapStopped", { text = "󰁕", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
