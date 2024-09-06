return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { '<space>p',  '<cmd>FzfLua resume<cr>',                desc = 'fzf Resume last command' },
      { '<space>/',  '<cmd>FzfLua live_grep<cr>',             desc = 'fzf live grep' },
      { '<space>w',  '<cmd>FzfLua grep_cword<cr>',            desc = 'fzf live grep' },
      { '<space>f',  '<cmd>FzfLua files<cr>',                 desc = 'fzf files' },
      { '<space>gb', '<cmd>FzfLua grep_curbuf<cr>',           desc = 'fzf current buffer' },
      -- { '<space>a',  '<cmd>FzfLua buffers<cr>',               desc = 'fzf buffers' },
      { '<space>b',  '<cmd>FzfLua buffers cwd_only=true<cr>', desc = 'fzf cwd buffers' },
    },
    config = function()
      local fzf = require("fzf-lua")
      -- local actions = require "fzf-lua.actions"
      fzf.setup({
        actions = {
          -- buffers = {
          --   ["ctrl-j"] = function(_, opts) fzf.files({ query = opts.last_query, cwd = opts.cwd }) end,
          -- },
          -- files = {
          --   ["ctrl-j"] = function(_, opts) fzf.buffers({ query = opts.last_query, cwd = opts.cwd }) end,
          -- },
        }
      })
    end
  },
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
