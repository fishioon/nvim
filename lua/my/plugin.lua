vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/zbirenbaum/copilot.lua' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
  { src = 'https://github.com/fishioon/cmd.nvim' },
})

vim.schedule(function()
  require('mini.diff').setup()
  require('mini.files').setup()
  require('mini.git').setup()
  require('mini.surround').setup()
  require('mini.pairs').setup()
  require('mini.icons').setup()

  -- pick
  local pick = require('mini.pick')
  local extra = require('mini.extra')
  pick.setup()
  extra.setup()
  pick.registry.projects = function()
    local cwd = vim.fn.expand('~/git')
    local choose = function(item)
      vim.schedule(function() pick.builtin.files(nil, { source = { cwd = item.path } }) end)
    end
    return extra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end


  vim.diagnostic.config({ virtual_text = true })
  -- lsp config
  vim.lsp.config('*', {
    root_markers = { '.git' },
  })
  vim.lsp.config('jsonls', { cmd = { 'vscode-json-languageserver', '--stdio' }, filetypes = { 'json' } })
  vim.lsp.config('tsls',
    { cmd = { 'typescript-language-server', '--stdio' }, filetypes = { 'javascript', 'typescript' } })
  vim.lsp.config('yamls', { cmd = { 'yaml-language-server', '--stdio' }, filetypes = { 'yaml' } })
  vim.lsp.enable({ 'luals', 'gopls', 'tsls' })

  require('copilot').setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      debounce = 50,
      keymap = {
        accept = '<tab>',
      },
    },
    filetypes = {
      markdown = true,
      ["."] = false,
    },
    copilot_node_command = 'node', -- Node.js version must be > 18.x
  })

  require('blink.cmp').setup({
    keymap = { preset = 'enter' },
    completion = { documentation = { auto_show = true } },
    cmdline = {
      keymap = { preset = 'cmdline' },
      completion = { menu = { auto_show = true } },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  })
end)
