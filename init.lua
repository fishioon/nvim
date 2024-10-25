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
require('mini.deps').setup()

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- now(function() require('mini.starter').setup() end)
-- now(function() require('mini.sessions').setup() end)
-- now(function() require('mini.statusline').setup() end)
now(function()
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end)

-- later(function() require('mini.completion').setup({}) end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.extra').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.git').setup() end)
-- later(function() require('mini.pairs').setup() end)
--

later(function()
  require('mini.pairs').setup({ modes = { insert = true, command = false, terminal = false } })
  vim.keymap.set('i', '<CR>', 'v:lua.Config.cr_action()', { expr = true })
end)

-- later(function() require('mini.starter').setup() end)
later(function()
  local switch_picker = function()
    local query = MiniPick.get_picker_query() or {}
    MiniPick.stop()
    vim.ui.select(vim.tbl_keys(MiniPick.registry), {
      prompt = 'Switch picker with query: ' .. table.concat(query, ''),
    }, function(picker)
      if not picker then return end
      vim.cmd('Pick ' .. picker)
      local transfer_query = function() MiniPick.set_picker_query(query) end
      vim.api.nvim_create_autocmd('User',
        { pattern = 'MiniPickStart', once = true, callback = transfer_query })
    end)
  end
  require('mini.pick').setup({
    mappings = {
      switch = { char = '<C-k>', func = switch_picker },
    },
  })
  vim.ui.select = MiniPick.ui_select
end)
later(function() require('mini.surround').setup() end)

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
  add('neovim/nvim-lspconfig')
  require('core.lsp')
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
  add('rafamadriz/friendly-snippets')
  add({
    source = "saghen/blink.cmp",
    checkout = 'v0.4.1',
  })
  require('blink.cmp').setup({
    keymap = {
      accept = '<CR>',
      snippet_forward = "<c-j>",
      snippet_backward = "<c-k>",
    },
    windows = {
      documentation = {
        auto_show = false,
      },
    }
  })
end)

-- later(function()
--   add('MeanderingProgrammer/render-markdown.nvim')
--   require('render-markdown').setup({})
-- end)

-- later(function()
--   add('stevearc/conform.nvim')
--   require("conform").setup({
--     format_on_save = {
--       timeout_ms = 500,
--       lsp_format = "fallback",
--     },
--   })
-- end)

later(function()
  add('supermaven-inc/supermaven-nvim')
  require('supermaven-nvim').setup({})
end)

require('core.functions')
require('core.options')
require('core.statusline')
require('core.keymaps')
-- require('internal.completion')
