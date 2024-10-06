return {
	{
		"dbridges/vim-markdown-runner",
		config = function()
			-- markdown runnner
			vim.keymap.set("n", "<leader>r", ":MarkdownRunner<CR>")
			vim.keymap.set("n", "<leader>R", ":MarkdownRunnerInsert<CR>")
		end,
	},
}
