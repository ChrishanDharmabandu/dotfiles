return {
	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				-- theme = "molokai",
				clmponent_separators = "|",
				section_separators = "",
			},
		},
	},
}
