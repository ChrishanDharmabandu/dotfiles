return {
	-- {
	--   "catppuccin/nvim",
	--   lazy = false,
	--   name = "catppuccin",
	--   priority = 1000,
	--   config = function()
	--     vim.cmd.colorscheme "catppuccin-mocha"
	--   end
	-- }
	{
		"eldritch-theme/eldritch.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		init = function()
			vim.cmd.colorscheme("eldritch")
		end,
	},
}
