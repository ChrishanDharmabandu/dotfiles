-- ~/.config/nvim/lua/plugins/matrix.lua (or wherever your matrix-nvim config is)
return {
  'iruzo/matrix-nvim',
  name = 'matrix-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- First, load the colorscheme.
    -- This ensures other highlight groups (syntax, etc.) are set by matrix-nvim.
    vim.cmd[[colorscheme matrix]]

    -- Explicitly set the Normal background to black.
    -- '#000000' is pure black in hexadecimal RGB.
    -- 'black' is the standard terminal 16-color name for black.
    vim.api.nvim_set_hl(0, "Normal", { bg = "#000000", ctermbg = "black" })

    -- Also set NonText and EndOfBuffer to black for a consistent background
    vim.api.nvim_set_hl(0, "NonText", { bg = "#000000", ctermbg = "black" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#000000", ctermbg = "black" })

    -- Ensure termguicolors is enabled for accurate color rendering
    -- This should generally be at the top of your main init.lua
    vim.o.termguicolors = true
  end,
}
