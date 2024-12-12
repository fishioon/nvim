vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go' },
  root_markers = { 'go.mod' },
  settings = {
    gopls = {
      analyses = {
        unreachable = true,
        unusedvariable = true,
        unusedparams = true,
      },
      matcher = "CaseInsensitive",
      staticcheck = true,
      gofumpt = true,
    },
  },
})
