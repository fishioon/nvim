return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    enabled = true,
    keys = {
      { '<space>p', _G.fn('telescope.builtin', 'resume') },
      { '<space>f', _G.fn('telescope.builtin', 'find_files') },
      { '<space>/', _G.fn('telescope.builtin', 'live_grep') },
      { '<space>w', _G.fn('telescope.builtin', 'grep_string'),                  desc = 'search under word' },
      { '<space>a', _G.fn('telescope.builtin', 'buffers'),                      desc = 'all buffers' },
      { '<space>b', _G.fn('telescope.builtin', 'buffers', { cwd_only = true }), desc = 'cwd buffers' },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup {
        defaults = {
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
            },
          },
        }
      }
    end
  },
  {
    'fishioon/term.nvim',
    dev = true,
    dependencies = { 'fishioon/cmd.nvim', dev = true },
    event = 'VeryLazy',
    config = function()
      require('term').setup({})
      local function run_cmd(cmd)
        cmd = cmd or require('cmd').cmd()
        require('term').send(cmd .. '\n', false)
      end

      local function copy_cmd()
        local cmd = require('cmd').cmd()
        vim.fn.setreg('+', cmd)
      end

      vim.keymap.set("n", "<space>e", run_cmd, { silent = true })
      vim.keymap.set("n", "<space>y", copy_cmd, { silent = false })
      vim.keymap.set({ 'n', 't' }, "<M-j>", require('term').toggle, { silent = true })
    end
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

          -- Whether to use icons by default
          use_icons = true,

          -- Whether to set Vim's settings for statusline (make it always shown with
          -- 'laststatus' set to 2).
          -- To use global statusline, set this to `false` and 'laststatus' to 3.
          set_vim_settings = false,
        }
      )
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    event = 'VeryLazy',
    build = function() vim.fn["mkdp#util#install"]() end,
  },
}
