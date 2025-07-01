vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.schedule(function()
      vim.opt_local.conceallevel = 1
    end)
  end,
})

