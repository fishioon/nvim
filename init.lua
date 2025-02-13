-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local plugins = {
  {
    "folke/snacks.nvim",
    opts = {
      bigfile = {},
      bufdelete = {},
      animate = {},
      picker = {
        win = {
          input = {
            keys = {
              ['<c-t>'] = { 'edit_tab', mode = { 'n', 'i' } },
            },
          },
        },
      },
      toggle = {},
      dashboard = {},
    }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'nvim-treesitter.configs'.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "json", "go" },
        highlight = { enable = true },
        ignore_install = {},
        sync_install = false,
        auto_install = false,
        modules = {},
      })
    end,
  },
  {
    'fishioon/cmd.nvim',
    dependencies = { 'fishioon/term.nvim' },
  },
  {
    'williamboman/mason.nvim',
    event = "VeryLazy",
    config = function()
      require('mason').setup()
    end,
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.git').setup()
    end,
  },
  {
    'saghen/blink.cmp',
    event = "VeryLazy",
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        -- cmdline = {},
      },
    },
    opts_extend = { "sources.default" }
  },
  {
    'zbirenbaum/copilot.lua',
    event = "VeryLazy",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>"
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 50,
        keymap = {
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = true,
        ["."] = false,
      },
      copilot_node_command = 'node', -- Node.js version must be > 18.x
      server_opts_overrides = {},
    }
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    opts = {
      provider = "copilot",
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  }
}

-- Setup lazy.nvim
require("lazy").setup({
  spec = plugins,
  -- install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})
