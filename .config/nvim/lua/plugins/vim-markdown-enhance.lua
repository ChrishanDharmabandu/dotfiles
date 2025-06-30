return {
	"godlygeek/tabular",
	"preservim/vim-markdown",
	ft = { "markdown" },
	init = function()
		-- Recommended settings from the vim-markdown README:
		vim.g.vim_markdown_folding_disabled = 1
		vim.g.vim_markdown_conceal = 0
		vim.g.vim_markdown_conceal_code_blocks = 0
		vim.g.vim_markdown_no_default_key_mappings = 1
		vim.g.vim_markdown_new_list_item_indent = 0
		vim.g.vim_markdown_autowrite = 1
	end
}
