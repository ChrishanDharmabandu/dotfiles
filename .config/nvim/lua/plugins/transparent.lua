return {
	{
		"xiyaowong/transparent.nvim",
		priority = 1000, -- Ensure it loads early
		config = function()
			require("transparent").setup({
				extra_groups = {
					"NormalFloat", -- For floating panels (Lazy, Mason, LspInfo)
					"NvimTreeNormal", -- For NvimTree
					"NeoTreeNormal", -- For Neo-tree
					"NeoTreeNormalNC", -- For Neo-tree non-current window
				},
			})
			-- Enable transparency on startup
			vim.cmd("TransparentEnable")
		end,
	},
}
