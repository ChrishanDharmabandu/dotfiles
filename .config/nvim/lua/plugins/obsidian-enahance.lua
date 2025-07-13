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
    },
    ui = {
      enable = false,
    },
    completion = { nvim_cmp = true },
    new_notes_location = "current_dir",
    hl_groups = {
      ObsidianTodo = { bold = true, fg = "#f78c6c" },
      ObsidianDone = { bold = true, fg = "#89ddff" },
    },
    log_level = vim.log.levels.INFO,

    -- Add this callbacks section to add date on save
    callbacks = {
      -- This function runs before writing the note buffer
      pre_write_note = function(client, note)
        -- Add or update the 'date' field in frontmatter with current date in %Y-%m-%d format
        note:add_field("date", os.date("%Y-%m-%d"))
      end,
    },
  },
}

