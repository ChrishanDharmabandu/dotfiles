return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", "<leader>a", mark.add_file)
    vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu)

    vim.keymap.set("n", "<leader>ha", function() ui.nav_file(1) end)
    vim.keymap.set("n", "<leader>hs", function() ui.nav_file(2) end)
    vim.keymap.set("n", "<leader>hd", function() ui.nav_file(3) end)
    vim.keymap.set("n", "<leader>hf", function() ui.nav_file(4) end)
    vim.keymap.set("n", "<leader>hf", function() ui.nav_file(4) end)
    vim.keymap.set("n", "<leader>hj", function() ui.nav_next() end)
    vim.keymap.set("n", "<leader>hk", function() ui.nav_prev() end)
  end,
}
