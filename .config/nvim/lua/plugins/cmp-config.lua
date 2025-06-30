-- ~/.config/nvim/lua/plugins/cmp-config.lua

return {
	{
		"hrsh7th/nvim-cmp", -- This MUST be the main plugin listed here for completion
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- A source for nvim-cmp for LSP completions
			"L3MON4D3/LuaSnip", -- The core snippet engine
			"saadparwaiz1/cmp_luasnip", -- The nvim-cmp source for LuaSnip
			"rafamadriz/friendly-snippets", -- A collection of snippets for LuaSnip
			"hrsh7th/cmp-buffer", -- Buffer source for nvim-cmp
			"hrsh7th/cmp-path", -- Path source for nvim-cmp
		},
		config = function()
			-- This 'config' function runs ONLY AFTER nvim-cmp and all its dependencies are loaded.
			local cmp = require("cmp")
			-- Load VS Code style snippets for LuaSnip.
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					-- Define how nvim-cmp should expand snippets using LuaSnip.
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					-- Configure the appearance of the completion and documentation windows.
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					-- Keybindings for completion menu navigation and actions.
					["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll documentation window backward
					["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll documentation window forward
					["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
					["<C-e>"] = cmp.mapping.abort(), -- Abort completion
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selected item
				}),
				sources = cmp.config.sources({
					-- Define the order of completion sources.
					{ name = "nvim_lsp" }, -- LSP suggestions
					{ name = "luasnip" }, -- Snippets from LuaSnip
					{ name = "buffer" }, -- Words from current buffer
					{ name = "path" }, -- File system paths
				}, {
					{ name = "nvim_lua" }, -- Neovim Lua API
				}),
			})
		end,
	},
}
