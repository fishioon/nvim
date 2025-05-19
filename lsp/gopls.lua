return {
  cmd = { 'gopls' },
  filetypes = { 'go' },
  root_markers = { 'go.mod' },
  settings = {
    gopls = {
      analyses = {
        unreachable = true,
        unusedvariable = true,
        unusedparams = true,
        rangeint = false,
        modernize = false,
      },
      matcher = "CaseInsensitive",
      staticcheck = true,
      gofumpt = true,
    },
  },
}
