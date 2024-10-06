return {
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				icons = false,
				-- Map <leader>xq to toggle the Trouble plugin with quickfix list
				vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
			})
		end,
	},
}
