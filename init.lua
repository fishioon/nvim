-- Initialization =============================================================
pcall(function() vim.loader.enable() end)

vim.g.mapleader = ' '
vim.g.localmapleader = ' '
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
require('mini.deps').setup()

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  require('mini.icons').setup()
end)

later(function() require('mini.bracketed').setup() end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.git').setup() end)
later(function() require('mini.surround').setup() end)
later(function()
  require('mini.pairs').setup({ modes = { insert = true, command = true, terminal = true } })
end)
later(function()
  require('mini.pick').setup()
end)


later(function()
  add('neovim/nvim-lspconfig')
  require('core.lsp')
end)

later(function()
  require('mini.completion').setup({})
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

require('core.options')
require('core.statusline')
require('core.keymaps')
