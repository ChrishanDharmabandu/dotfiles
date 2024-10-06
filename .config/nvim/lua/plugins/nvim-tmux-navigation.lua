return {
  "alexghergh/nvim-tmux-navigation",
  config = function()
    require('nvim-tmux-navigation').setup({})
    vim.api.nvim_set_keymap("n", "<M-h>", ':echo "Navigate Left"<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<M-j>", ':echo "Navigate Down"<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<M-k>", ':echo "Navigate Up"<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<M-l>", ':echo "Navigate Right"<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<M-\\>", ':echo "Navigate Back"<CR>', { noremap = true, silent = true })

  end,
}
