return {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = function()
    -- conditionally use the correct build system for the current OS
    if vim.fn.has("win32") == 1 then
      return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    else
      return "make"
    end
  end,
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = "openai",         -- Default provider
    model = "gpt-4o-mini",       -- Default model (must match provider's model)
    provider = "gemini",         -- Default provider
    model = "gemini-2.0-flash",       -- Default model (must match provider's model)

    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
        -- api_key = os.getenv("ANTHROPIC_API_KEY"),
      },

      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o-mini",
        timeout = 30000,
        extra_request_body = {
          temperature = 0.7,
          max_tokens = 4096,
        },
        api_key = os.getenv("OPENAI_API_KEY"),
      },

      ollama = {
        endpoint = "http://localhost:11434/api",
        model = "llama3",
        timeout = 60000,
        extra_request_body = {
          temperature = 0.7,
          options = {
            num_ctx = 4096,
          },
        },
      },
    },
  },

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.pick",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "stevearc/dressing.nvim",
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}

