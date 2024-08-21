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
        local line = [[put =execute('!]] .. cmd .. [[')]]
        vim.cmd(line)
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
    'echasnovski/mini.nvim',
    version = '*',
    keys = {
      { '<space>gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>' },
    },
    event = 'VeryLazy',
    config = function()
      require('mini.bracketed').setup()
      require('mini.git').setup()
      require('mini.surround').setup()
      require('mini.diff').setup()
      require('mini.pairs').setup()
      local statusline = require('mini.statusline')
      statusline.setup(
        {
          content = {
            active = function()
              local m           = statusline
              local git         = m.section_git({ trunc_width = 40 })
              local diff        = m.section_diff({ trunc_width = 75 })
              local diagnostics = m.section_diagnostics({ trunc_width = 75 })
              local lsp         = m.section_lsp({ trunc_width = 75 })
              local fileinfo    = m.section_fileinfo({ trunc_width = 120 })
              local location    = m.section_location({ trunc_width = 75 })
              local search      = m.section_searchcount({ trunc_width = 75 })
              local cwd         = vim.fn.getcwd():match("([^/]+)$")
              return m.combine_groups({
                { strings = { '[' .. cwd .. ']', '%f%m%r' } },
                '%<', -- Mark general truncate point
                { strings = { git, lsp, diff, diagnostics } },
                '%=', -- End left alignment
                { strings = { fileinfo } },
                { strings = { search, location } },
              })
            end,
            inactive = nil,
          },
          use_icons = true,
          set_vim_settings = false,
        }
      )
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
    enabled = false,
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
}
