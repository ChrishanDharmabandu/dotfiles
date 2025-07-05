return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim", -- optional but recommended
    "hrsh7th/nvim-cmp",              -- for completion
    "L3MON4D3/LuaSnip",              -- for snippets
    "rafamadriz/friendly-snippets",  -- for common snippets
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Documents/syncthing/notes/",
      },
      -- {
      --   name = "work",
      --   path = "~/vaults/work",
      -- },
    },
    ui = {
      enable = false,
    },
    completion = { nvim_cmp = true }, -- enable nvim-cmp integration
    new_notes_location = "current_dir", -- or "notes_subdir"
    -- notes_subdir = "notes", -- if you keep notes in a subdirectory
    -- daily_notes = {
    --   folder = "daily",
    --   date_format = "%Y-%m-%d",
    -- },
    -- templates = {
    --   folder = "templates",
    --   date_format = "%Y-%m-%d",
    --   time_format = "%H:%M",
    -- },
    -- Optional: highlight settings
    hl_groups = {
      ObsidianTodo = { bold = true, fg = "#f78c6c" },
      ObsidianDone = { bold = true, fg = "#89ddff" },
      -- ...add more as desired
    },
    -- Optional: set log level for debugging
    log_level = vim.log.levels.INFO,
  },
}

