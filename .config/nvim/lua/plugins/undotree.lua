return {
  {
    "mbbill/undotree",
    config = function()
      -- Keymap for Ctrl+Shift+U to toggle Undotree
      vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr> | <cmd>UndotreeFocus<cr>", { desc = "Toggle Undotree", silent = true, noremap = true })
    end,
  },
}

