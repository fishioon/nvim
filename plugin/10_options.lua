vim.g.mapleader      = ' '
vim.o.mouse          = 'a'
vim.o.cursorline     = true
vim.o.number         = true
vim.o.relativenumber = true
vim.o.signcolumn     = 'number'
vim.o.ignorecase     = true
vim.o.smartcase      = true
vim.o.laststatus     = 3
vim.o.splitbelow     = true
vim.o.splitright     = true
vim.o.foldmethod     = 'expr'
vim.o.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel      = 4
vim.o.tabstop        = 4
vim.o.cmdheight      = 0
-- vim.o.shortmess      = vim.o.shortmess .. 'W'

vim.diagnostic.config({
  -- virtual_lines = true,
})

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

vim.lsp.enable({ 'luals', 'gopls', 'jsonls', 'tsls' })

vim.api.nvim_set_hl(0, 'SnacksPickerDir', {
  link = 'Comment',
})
