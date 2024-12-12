vim.loader.enable()
vim.g.mapleader = ' '
vim.g.localmapleader = ' '
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

if not Config then
  _G.Config = {}
end

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

-- later(function() require('mini.diff').setup() end)
-- later(function() require('mini.git').setup() end)
later(function() require('mini.extra').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.ai').setup() end)
later(function() require('mini.completion').setup() end)
later(function() require('mini.surround').setup() end)
later(function()
  require('mini.pairs').setup({ modes = { insert = true, command = true, terminal = true } })
  -- vim.keymap.set('i', '<CR>', 'v:lua.Config.cr_action()', { expr = true })
end)

later(function()
  require('mini.pick').setup({ window = { config = { border = 'double' } } })
  vim.ui.select = MiniPick.ui_select
  vim.keymap.set('n', ',', [[<Cmd>Pick buf_lines scope='current' preserve_order=true<CR>]], { nowait = true })

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
  require('cmd').setup()
  require('term').setup({})
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
      hide_during_completion = true,
      debounce = 75,
      keymap = {
        accept = "<tab>",
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
  require('avante_lib').load()
  require("avante").setup({
    debug = false,
    provider = "copilot",
    auto_suggestions_provider = "copilot",
    behaviour = {
      auto_suggestions = false, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },
    mappings = {
      toggle = {
        default = "<leader>aa",
        debug = "<leader>ad",
        hint = "<leader>ah",
        suggestion = "<leader>as",
        repomap = "<leader>aR",
      },
    },
  }) -- config for avante.nvim
end)

-- https://microsoft.github.io/language-server-protocol/implementors/servers/
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

later(function() vim.lsp.enable({ 'luals', 'gopls', 'jsonls' }) end)

require('core.functions')
require('core.options')
require('core.statusline')
require('core.keymaps')
