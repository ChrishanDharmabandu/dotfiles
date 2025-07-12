
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
    -- Set your preferred default provider here
    -- provider = "claude", -- Example: default to Claude
    -- provider = "openai", -- Example: default to OpenAI
    provider = "ollama", -- Example: default to Ollama

    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
        -- It's recommended to use environment variables for API keys for security.
        -- Example: api_key = os.getenv("ANTHROPIC_API_KEY"),
        -- For testing, you can hardcode, but avoid in production:
        -- api_key = "YOUR_ANTHROPIC_API_KEY_HERE",
      },
      -- OpenAI API configuration
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o-mini", -- Or "gpt-3.5-turbo", "gpt-4-turbo", etc.
        timeout = 30000,
        extra_request_body = {
          temperature = 0.7,
          max_tokens = 4096,
        },
        -- Use an environment variable for your OpenAI API key
        api_key = os.getenv("OPENAI_API_KEY"),
        -- Or, if you must hardcode (not recommended):
        -- api_key = "YOUR_OPENAI_API_KEY_HERE",
      },
      -- Local MLX API configuration (assuming it exposes an OpenAI-compatible API)
      mlx = {
        endpoint = "http://localhost:8080/v1", -- Common default port for MLX
        model = "mlx-model", -- Replace with the actual model name if MLX serves one
        timeout = 60000, -- May need a longer timeout for local models
        extra_request_body = {
          temperature = 0.7,
          max_tokens = 4096,
        },
      },
      -- Llama.cpp configuration (assuming it exposes an OpenAI-compatible API)
      llamacpp = {
        endpoint = "http://localhost:8080/v1", -- Default llama.cpp server endpoint
        model = "llama.cpp", -- Replace with your specific model filename
        timeout = 60000,
        extra_request_body = {
          temperature = 0.7,
          max_tokens = 4096,
        },
      },
      -- LM Studio configuration (exposes an OpenAI-compatible API)
      lmstudio = {
        endpoint = "http://localhost:1234/v1", -- Default LM Studio server endpoint
        model = "lm-studio-model", -- Replace with the model name loaded in LM Studio
        timeout = 60000,
        extra_request_body = {
          temperature = 0.7,
          max_tokens = 4096,
        },
      },
      -- Ollama configuration
      ollama = {
        endpoint = "http://localhost:11434/api", -- Default Ollama API endpoint
        model = "llama3", -- Replace with the model you've pulled (e.g., "llama2", "mistral", "codellama")
        timeout = 60000,
        -- Ollama has a slightly different API for chat completions
        -- You might need to adjust `extra_request_body` or how Avante interacts with it
        -- based on Avante's specific Ollama integration.
        -- This is a common structure for Ollama's chat endpoint:
        extra_request_body = {
          temperature = 0.7,
          options = {
            num_ctx = 4096, -- Context window size
          },
        },
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}

