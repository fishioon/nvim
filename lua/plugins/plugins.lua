return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { '<space>p', '<cmd>FzfLua resume<cr>',                desc = 'fzf Resume last command' },
      { '<space>f', '<cmd>FzfLua files<cr>',                 desc = 'fzf files' },
      { '<space>/', '<cmd>FzfLua live_grep<cr>',             desc = 'fzf live grep' },
      { '<space>w', '<cmd>FzfLua grep_cword<cr>',            desc = 'fzf live grep' },
      { '<space>a', '<cmd>FzfLua buffers<cr>',               desc = 'fzf buffers' },
      { '<space>b', '<cmd>FzfLua buffers cwd_only=true<cr>', desc = 'fzf buffers' },
    },
    config = function()
      local fzf = require("fzf-lua")
      -- local actions = require "fzf-lua.actions"
      fzf.setup({
        actions = {
          buffers = {
            true,
            ["ctrl-j"] = function(_, opts) fzf.files({ query = opts.last_query, cwd = opts.cwd }) end,
          },
          files = {
            true,
            ["ctrl-j"] = function(_, opts) fzf.buffers({ query = opts.last_query, cwd = opts.cwd }) end,
          },
        }
      })
    end
  },
  -- {
  --   'nvim-telescope/telescope.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   enabled = false,
  --   keys = {
  --     { '<space>p', _G.fn('telescope.builtin', 'resume'),                       'resume' },
  --     { '<space>f', _G.fn('telescope.builtin', 'find_files'),                   'find files' },
  --     { '<space>/', _G.fn('telescope.builtin', 'live_grep'),                    desc = 'live grep' },
  --     { '<space>w', _G.fn('telescope.builtin', 'grep_string'),                  desc = 'search under word' },
  --     { '<space>a', _G.fn('telescope.builtin', 'buffers'),                      desc = 'all buffers' },
  --     { '<space>b', _G.fn('telescope.builtin', 'buffers', { cwd_only = true }), desc = 'cwd buffers' },
  --   },
  --   config = function()
  --     local actions = require("telescope.actions")
  --     require("telescope").setup {
  --       defaults = {
  --         mappings = {
  --           i = {
  --             ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
  --           },
  --         },
  --       }
  --     }
  --   end
  -- },
  {
    'fishioon/term.nvim',
    dependencies = { 'fishioon/cmd.nvim', dev = true },
    keys = {
      { '<space>e', function()
        local cmd = require('cmd').cmd()
        require('term').send(cmd .. '\n', false)
      end },
      { '<space>y', function()
        local cmd = require('cmd').cmd()
        vim.fn.setreg('+', cmd)
      end },
      {
        '<M-m>',
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
              local _, mode_hl  = m.section_mode({ trunc_width = 120 })
              local git         = m.section_git({ trunc_width = 40 })
              local diff        = m.section_diff({ trunc_width = 75 })
              local diagnostics = m.section_diagnostics({ trunc_width = 75 })
              local lsp         = m.section_lsp({ trunc_width = 75 })
              local fileinfo    = m.section_fileinfo({ trunc_width = 120 })
              local location    = m.section_location({ trunc_width = 75 })
              local search      = m.section_searchcount({ trunc_width = 75 })
              local cwd         = vim.fn.getcwd():match("([^/]+)$")
              return m.combine_groups({
                { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
                '%<', -- Mark general truncate point
                { hl = 'MiniStatuslineFilename', strings = { '[' .. cwd .. ']', '%f%m%r' } },
                '%=', -- End left alignment
                { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                { hl = mode_hl,                  strings = { search, location } },
              })
            end,
            -- Content for inactive window(s)
            inactive = nil,
          },
          use_icons = true,
          set_vim_settings = false,
        }
      )
      -- require('mini.completion').setup()
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    event = 'VeryLazy',
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
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
    config = function()
      local snipe = require("snipe")
      snipe.setup()
      vim.keymap.set("n", "gb", snipe.create_buffer_menu_toggler())
    end,
  }
}
