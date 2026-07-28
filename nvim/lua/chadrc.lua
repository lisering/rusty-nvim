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
	},
}

-- Disable NvChad built-in signature help, use blink.cmp signature instead
M.lsp = { signature = false }

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

return M
