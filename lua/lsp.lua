local lspconfig = require('lspconfig')
local opts = {
  inlay_hints = { enabled = true },
  servers = {
    bashls = {},
    clangd = {},
    ts_ls = {},
    jsonls = {},
    gopls = {
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
    },
    golangci_lint_ls = {
      init_options = {
        command = { "golangci-lint", "run", "--out-format", "json", "--allow-parallel-runners" }
      }
    },
    lua_ls = {
      settings = {
        Lua = {
          hint = {
            enable = true, -- necessary
          },
          diagnostics = {
            globals = { 'ngx' }
          },
          runtime = {
            version = 'LuaJIT'
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              "${3rd}/luv/library",
            }
          }
        },
      },
    },
  },
}

for server, opt in pairs(opts.servers) do
  lspconfig[server].setup(opt)
end
