return {
  -- Example Lazy.nvim configuration for bullets.vim
  {
    "dkarter/bullets.vim",
    -- Key options for lazy loading:
    ft = { "markdown", "text", "vimwiki" }, -- Load for these filetypes
    event = "InsertCharPre", -- Load just before a character is inserted (good for auto-bullets)
    -- Or:
    -- event = "BufEnter", -- Load when entering a buffer
    -- event = "InsertEnter", -- Load when entering insert mode
    -- Or even:
    -- keys = { { "<CR>", mode = "i" } }, -- Load when <CR> is pressed in insert mode
  },
}
