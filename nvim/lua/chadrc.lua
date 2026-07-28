-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "onedark",

	hl_override = {
		-- Cursor line: high-contrast background
		CursorLine = { bg = "#333a47", bold = false },
		CursorLineNr = { fg = "#e5c07b", bold = true },
		CursorColumn = { bg = "#333a47" },
		LineNr = { fg = "#3b4048" },
		-- Cursor line left bar: vivid orange
		CursorLineBar = { fg = "#e06c75", bg = "#333a47", bold = true },
		-- Nvdash header: Rust orange
		NvDashAscii = { fg = "#ce422b", bold = true },
		NvDashButtons = { fg = "#abb2bf" },
	},
}

-- Disable NvChad built-in signature help, use blink.cmp signature instead
M.lsp = { signature = false }

M.nvdash = {
	load_on_startup = true,
	header = {
		"                                                     ",
		"                                                     ",
		"                    rusty-nvim                       ",
		"                                                     ",
		"         A batteries-included Neovim config for Rust ",
		"                                                     ",
	},
	buttons = {
		{ txt = "▸  Find File",    keys = "ff", cmd = "Telescope find_files" },
		{ txt = "▸  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
		{ txt = "▸  Find Word",    keys = "fw", cmd = "Telescope live_grep" },
		{ txt = "▸  Themes",       keys = "th", cmd = ":lua require('nvchad.themes').open()" },
		{ txt = "▸  Mappings",     keys = "ch", cmd = "NvCheatsheet" },
		{ txt = "▸  Quit",         keys = "q",  cmd = "qa" },

		{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

		{
			txt = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime) .. " ms"
				return "▸  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
			end,
			hl = "NvDashFooter",
			no_gap = true,
			content = "fit",
		},

		{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
	},
}

return M
