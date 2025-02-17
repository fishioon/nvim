--q Bootstrap lazy.nvim
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
    priority = 1000,
    lazy = false,
    opts = {
      animate = {},
      bigfile = {},
      bufdelete = {},
      dashboard = {},
      image = {},
      input = {},
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
      explorer = {},
      notifier = {},
    },
    keys = {
      { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Find Files" },
      { "<leader>,",       function() Snacks.picker.buffers({ filter = { cwd = true } }) end,      desc = "Buffers" },
      { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<leader>;",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
      { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
      { "<leader>gc",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
      { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      { "<leader>fb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      { "<leader>fB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
      { "<leader>fw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
      { '<leader>f"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
      { "<leader>fa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
      { "<leader>fC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
      { "<leader>fd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>fh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
      { "<leader>fH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
      { "<leader>fj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
      { "<leader>fk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
      { "<leader>fl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
      { "<leader>fM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
      { "<leader>fm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
      { "<leader>fR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
      { "<leader>fq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
      { "<leader>fC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
      { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
      { "<leader>fe",      function() Snacks.picker.explorer() end,                                desc = "explorer" },

      { '<leader>gg',      function() Snacks.lazygit() end,                                        desc = 'Lazygit' },
      { "<leader>z",       function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
      { "<leader>Z",       function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
      { "<leader>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
      { "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
      -- { "<leader>n",       function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
      { "<leader>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
      { "<leader>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
      { "<leader>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },
      { "<leader>gg",      function() Snacks.lazygit() end,                                        desc = "Lazygit" },
      { "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
      -- toggle
      { "<leader>ud",      function() Snacks.toggle.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>ul",      function() Snacks.toggle.line_number() end,                             desc = "Line Number" },
      { "<leader>uT",      function() Snacks.toggle.treesitter() end,                              desc = "Treesitter" },
      { "<leader>uh",      function() Snacks.toggle.inlay_hints() end,                             desc = "Inlay Hints" },
      { "<leader>ug",      function() Snacks.toggle.indent() end,                                  desc = "Indent" },
      { "<leader>uD",      function() Snacks.toggle.dim() end,                                     desc = "Dim" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 500,
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
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
    keys = {
      { '<leader>r',  function() require('term').send(require('cmd').cmd() .. '\n') end, desc = 'Execute command terminal' },
      {
        '<leader>eo',
        function()
          local cmd = require('cmd').cmd()
          local output = vim.fn.systemlist(cmd)
          local current_line = vim.api.nvim_win_get_cursor(0)[1]
          vim.api.nvim_buf_set_lines(0, current_line, current_line, false, output)
        end,
        desc = 'Execute command output buffer'
      },
      { '<leader>ey', function() vim.fn.setreg('+', require('cmd').cmd()) end,           desc = 'Execute command output yank' },
    }
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
      require('mini.diff').setup()
      require('mini.surround').setup()
      require('mini.statusline').setup()
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
    disabled = true,
    lazy = false,
    version = '*',
    opts = {
      provider = "copilot",
    },
    dependencies = {
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
