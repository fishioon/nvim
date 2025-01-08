MiniDeps.later(function()
  MiniDeps.add('williamboman/mason.nvim')
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

MiniDeps.later(function()
  local function build_blink(params)
    vim.notify('Building blink.cmp', vim.log.levels.INFO)
    local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
    if obj.code == 0 then
      vim.notify('Building blink.cmp done', vim.log.levels.INFO)
    else
      vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
    end
  end

  MiniDeps.add({
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

