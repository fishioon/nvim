vim.loader.enable()
vim.g.mapleader = vim.keycode('<space>')
vim.g.maplocalleader = vim.keycode('<space>')
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(mini_path) then
  vim.cmd([[echo "Installing 'mini.nvim'" | redraw]])
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
end

local MiniDeps = require('mini.deps')
MiniDeps.setup()

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end)

now(function()
  add('folke/tokyonight.nvim')
  -- vim.cmd.colorscheme('tokyonight')
end)

later(function() require('mini.ai').setup() end)
later(function() require('mini.animate').setup() end)
later(function() require('mini.completion').setup() end)
later(function() require('mini.cursorword').setup() end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.extra').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.git').setup() end)
later(function() require('mini.pairs').setup() end)
-- later(function() require('mini.completion').setup() end)
-- local gen_loader = require('mini.snippets').gen_loader
-- require('mini.snippets').setup({
--   snippets = {
--     gen_loader.from_file('~/.config/nvim/snippets/global.json'),
--     gen_loader.from_lang(),
--   },
-- })

later(function()
  require('mini.pick').setup({ window = { config = { border = 'double' } } })
  vim.ui.select = MiniPick.ui_select
  vim.keymap.set('n', ',', [[<Cmd>Pick buf_lines scope='current' preserve_order=true<CR>]])

  MiniPick.registry.projects = function()
    local cwd = vim.fn.expand('~/repos')
    local choose = function(item)
      vim.schedule(function() MiniPick.builtin.files(nil, { source = { cwd = item.path } }) end)
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end
end)

later(function()
  local miniclue = require('mini.clue')
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end)

later(function()
  add('folke/snacks.nvim')
  require('snacks').setup({
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
  })
end)

later(function()
  add('nvim-treesitter/nvim-treesitter')
  add('nvim-treesitter/nvim-treesitter-textobjects')
  require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "json", "go" },
    highlight = { enable = true },
    ignore_install = {},
    sync_install = false,
    auto_install = false,
    modules = {},
  })
end)

later(function()
  add('fishioon/cmd.nvim')
  add('fishioon/term.nvim')
  -- require('cmd').setup()
  -- require('term').setup({})
end)

later(function()
  add('zbirenbaum/copilot.lua')
  add({
    source = 'yetone/avante.nvim',
    monitor = 'main',
    depends = {
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
  })
  require('copilot').setup({
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
      layout = {
        position = "bottom", -- | top | left | right
        ratio = 0.4
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
  })
end)


-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
-- later(function()
--   add('zbirenbaum/copilot.lua')
--   add({
--     source = 'yetone/avante.nvim',
--     monitor = 'main',
--     depends = {
--       'stevearc/dressing.nvim',
--       'nvim-lua/plenary.nvim',
--       'MunifTanjim/nui.nvim',
--     },
--   })
--   require('copilot').setup({
--     panel = {
--       enabled = true,
--       auto_refresh = false,
--       keymap = {
--         jump_prev = "[[",
--         jump_next = "]]",
--         accept = "<CR>",
--         refresh = "gr",
--         open = "<M-CR>"
--       },
--       layout = {
--         position = "bottom", -- | top | left | right
--         ratio = 0.4
--       },
--     },
--     suggestion = {
--       enabled = true,
--       auto_trigger = true,
--       hide_during_completion = false,
--       debounce = 50,
--       keymap = {
--         accept = "<C-l>",
--         accept_word = false,
--         accept_line = false,
--         next = "<M-]>",
--         prev = "<M-[>",
--         dismiss = "<C-]>",
--       },
--     },
--     filetypes = {
--       yaml = true,
--       markdown = true,
--       help = false,
--       gitcommit = true,
--       gitrebase = true,
--       ["."] = false,
--     },
--     copilot_node_command = 'node', -- Node.js version must be > 18.x
--     server_opts_overrides = {},
--   })
--   -- require('avante_lib').load()
--   -- require("avante").setup({
--   --   debug = false,
--   --   provider = "copilot",
--   --   auto_suggestions_provider = "copilot",
--   --   behaviour = {
--   --     auto_suggestions = false, -- Experimental stage
--   --     auto_set_highlight_group = true,
--   --     auto_set_keymaps = true,
--   --     auto_apply_diff_after_generation = false,
--   --     support_paste_from_clipboard = false,
--   --   },
--   --   mappings = {
--   --     toggle = {
--   --       default = "<leader>aa",
--   --       debug = "<leader>ad",
--   --       hint = "<leader>ah",
--   --       suggestion = "<leader>as",
--   --       repomap = "<leader>aR",
--   --     },
--   --   },
--   -- }) -- config for avante.nvim
-- end)

later(function()
  add('williamboman/mason.nvim')
  require('mason').setup()

  vim.lsp.config('*', {
    capabilities = {
      textDocument = {
        semanticTokens = {
          multilineTokenSupport = true,
        }
      }
    },
    root_markers = { '.git' },
  })
  vim.lsp.config('jsonls', {
    cmd = { 'vscode-json-languageserver', '--stdio' },
    filetypes = { 'json' },
  })
  vim.lsp.config('tsls', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'typescript' },
  })

  vim.lsp.config('yamls', {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml' },
  })

  vim.lsp.config('sqlls', {
    cmd = { 'sqlls-language-server', '--stdio' },
    filetypes = { 'sql' },
  })

  vim.lsp.config('helmls', {
    cmd = { 'helm_ls', 'serve' },
    filetypes = { 'helm' },
  })

  vim.lsp.enable({ 'luals', 'gopls', 'jsonls', 'tsls', 'yamls', 'helmls' })
end)

-- https://microsoft.github.io/language-server-protocol/implementors/servers/

later(function()
  local function build_blink(params)
    vim.notify('Building blink.cmp', vim.log.levels.INFO)
    local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
    if obj.code == 0 then
      vim.notify('Building blink.cmp done', vim.log.levels.INFO)
    else
      vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
    end
  end

  add({
    source = "saghen/blink.cmp",
    depends = {
      "rafamadriz/friendly-snippets",
    },
    hooks = {
      post_install = build_blink,
      post_checkout = build_blink,
    },
  })

  require('blink.cmp').setup({
    keymap = {
      preset = 'enter',
      cmdline = {
        preset = 'default',
      },
    }
  })
end)

require('core.options')
require('core.keymaps')
require('core.statusline')
