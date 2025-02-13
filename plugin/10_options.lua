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
vim.o.foldenable     = true
vim.o.foldlevel      = 99 -- start editing with all folds opened
vim.o.tabstop        = 4
vim.o.cmdheight      = 1
vim.o.switchbuf      = 'usetab'

vim.diagnostic.config({
  virtual_lines = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    },
  },
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
