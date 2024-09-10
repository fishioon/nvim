return {
  {
    'fishioon/term.nvim',
    dev = true,
    dependencies = { 'fishioon/cmd.nvim', dev = true },
    keys = {
      { '<space>ee', function()
        local cmd = require('cmd').cmd()
        require('term').send(cmd .. '\n', false)
      end },
      { '<space>eo', function()
        local cmd = require('cmd').cmd()
        local output = vim.fn.systemlist(cmd)
        local current_line = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, current_line, current_line, false, output)
      end },
      { '<space>ey', function()
        local cmd = require('cmd').cmd()
        vim.fn.setreg('+', cmd)
      end },
      {
        '<D-j>',
        function()
          require('term').toggle()
        end,
        mode = { 'n', 't' }
      },
    },
    config = true,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {},
    config = function()
      require 'nvim-treesitter.configs'.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "json", "go" },
        highlight = { enable = true }
      })
    end
  },
  {
    enabled = false,
    'folke/tokyonight.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  {
    'echasnovski/mini.nvim',
    version = false,
    keys = {
      { '<space>gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>' },
      { '<space>mo', '<Cmd>lua MiniFiles.open()<CR>' },
    },
    event = 'VeryLazy',
    config = function()
      require('mini.bracketed').setup()
      require('mini.git').setup()
      require('mini.surround').setup()
      require('mini.diff').setup()
      require('mini.pairs').setup()
      require('mini.files').setup()
      -- require('mini.statusline').setup()
    end
  },
  {
    -- enabled = false,
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 800,
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "leath-dub/snipe.nvim",
    keys = {
      { "gb", function() require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu" }
    },
    opts = {}
  }
}
