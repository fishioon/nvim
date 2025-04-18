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
  -- {
  --   "rebelot/kanagawa.nvim",
  -- },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.diff').setup({
        view = {
          style = 'number',
          priority = 9
        },
      })
      require('mini.git').setup()
      require('mini.icons').setup()
      require('mini.pairs').setup()
      require('mini.statusline').setup()
      require('mini.surround').setup()
      -- require('mini.completion').setup()
      -- require('mini.snippets').setup()
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = {
        replace_netrw = true,
      },
      indent = { enabled = true },
      input = { enabled = true },
      -- notifier = { enabled = true },
      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ['<c-t>'] = { 'edit_tab', mode = { 'n', 'i' } },
            },
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
      image = { enabled = true },
    },
    keys = {
      { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Find Files" },
      { "<leader>,",       function() Snacks.picker.buffers({ filter = { cwd = true } }) end,      desc = "Buffers cwd" },
      { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<leader>;",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
      { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
      { "<leader>gc",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
      { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
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
      { "<leader>fr",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
      { "<leader>fq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
      { "<leader>fC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
      { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
      { "<leader>fe",      function() Snacks.picker.explorer() end,                                desc = "explorer" },
      { "<leader>.",       function() Snacks.picker.lines() end,                                   desc = "lines" },
      { '<leader>gg',      function() Snacks.lazygit() end,                                        desc = 'Lazygit' },
      { "<leader>z",       function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
      { "<leader>Z",       function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
      { "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
      { "<leader>mh",      function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
      { "<leader>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
      { "<leader>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
      { "<leader>gb",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },
      { "<leader>gg",      function() Snacks.lazygit() end,                                        desc = "Lazygit" },
      { "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
      { "<leader>ud",      function() Snacks.toggle.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>ul",      function() Snacks.toggle.line_number() end,                             desc = "Line Number" },
      { "<leader>uT",      function() Snacks.toggle.treesitter() end,                              desc = "Treesitter" },
      { "<leader>uh",      function() Snacks.toggle.inlay_hints() end,                             desc = "Inlay Hints" },
      { "<leader>ug",      function() Snacks.toggle.indent() end,                                  desc = "Indent" },
      { "<leader>uD",      function() Snacks.toggle.dim() end,                                     desc = "Dim" },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = { "BufReadPost", "BufNewFile" },
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
      { '<C-/>',     function() require('term').toggle() end,                           desc = 'Toggle command terminal', mode = { 'n', 't' } },
      { '<leader>r', function() require('term').send(require('cmd').cmd() .. '\n') end, desc = 'Execute command terminal' },
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
      { '<leader>ey', function() vim.fn.setreg('+', require('cmd').cmd()) end, desc = 'Execute command output yank' },
    }
  },
  {
    'mcauley-penney/visual-whitespace.nvim',
    config = true,
    -- keys = { 'v', 'V', '<C-v>' }, -- optionally, lazy load on visual mode keys
  },
  {
    'zbirenbaum/copilot.lua',
    disable = false,
    event = "VeryLazy",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 50,
        keymap = {
          accept = "<Tab>",
        },
      },
      filetypes = {
        markdown = true,
        ["."] = false,
      },
      copilot_node_command = 'node', -- Node.js version must be > 18.x
    }
  },
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      -- keymap = { preset = 'default' },
      keymap = { preset = 'super-tab' },

      appearance = {
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      cmdline = {
        enabled = true,
        keymap = {
          ['<Tab>'] = { 'show', 'accept' },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  }
}

-- Setup lazy.nvim
require("lazy").setup({
  spec = plugins,
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      }
    }
  }
})
