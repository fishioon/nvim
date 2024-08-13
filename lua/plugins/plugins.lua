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
      { '<space>a',  '<cmd>FzfLua buffers<cr>',               desc = 'fzf buffers' },
      { '<space>b',  '<cmd>FzfLua buffers cwd_only=true<cr>', desc = 'fzf buffers' },
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
  {
    'fishioon/term.nvim',
    dev = true,
    dependencies = { 'fishioon/cmd.nvim', dev = true },
    keys = {
      { '<space>ee', function()
        local cmd = require('cmd').cmd()
        require('term').send(cmd .. '\n', false)
      end },
      { '<space>ec', function()
        local cmd = require('cmd').cmd()
        vim.cmd('silent !' .. cmd)
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
  -- lazy.nvim
  {
    "robitx/gp.nvim",
    dev = true,
    keys = {
      { '<D-l>', '<cmd>GpChatToggle<cr>', desc = 'gp toggle' },
    },
    config = function()
      require("gp").setup({
        providers = {
          ollama = {
            endpoint = "https://gateway.mpi.shopee.io/ufs/v1/internal_openai_v1/chat/completions",
          },
        },
        curl_params = {
          "--header", "Authorization: HMAC Signature=8e726e7872134f0f052a76faff42392a1e99a3206acc2f996627ea799f75a187",
          "--header", "X-UFS-AppID: liyi",
        },
        agents = {
          {
            provider = "ollama",
            name = "llama3.1",
            chat = true,
            command = false,
            model = { model = "llama-3.1-8b-instruct" },
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
        }
      })
    end,
  },
}
