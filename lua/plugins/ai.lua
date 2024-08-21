return {
  {
    enabled = false,
    "yetone/avante.nvim",
    opts = {},
    build = "make",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "grapp-dev/nui-components.nvim",
        dependencies = {
          "MunifTanjim/nui.nvim"
        }
      },
      "nvim-lua/plenary.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    config = function()
      require('avante').setup({
        provider = "openai", -- "claude" or "openai" or "azure"
        openai = {
          endpoint = "https://chatgpt.shopee.io",
          model = "gpt-4o",
          temperature = 0,
          max_tokens = 4096,
        },
        mappings = {
          ask = "<space>aa",
          edit = "<space>ae",
          refresh = "<space>ar",
          --- @class AvanteConflictMappings
          diff = {
            ours = "co",
            theirs = "ct",
            none = "c0",
            both = "cb",
            next = "]x",
            prev = "[x",
          },
          jump = {
            next = "]]",
            prev = "[[",
          },
        },
      })
    end
  },
  -- lazy.nvim
  {
    enabled = false,
    "robitx/gp.nvim",
    event = "VeryLazy",
    config = function()
      local conf = {
        -- For customization, refer to Install > Configuration in the Documentation/Readme
        providers = {
          openai = {
            endpoint = "https://chatgpt.shopee.io/v1/chat/completions",
          }
        },
        agents = {
          {
            provider = "openai",
            name = "ChatGPT4o-mini",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o-mini", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
        }
      }
      require("gp").setup(conf)
      vim.keymap.set({ "n", "i" }, "<D-l>", "<cmd>GpChatToggle<cr>")
      -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
    end,
  },
}
