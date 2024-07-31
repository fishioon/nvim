return {
  {
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
    opts = {
      inlay_hints = { enabled = true },
      servers = {
        bashls = {},
        clangd = {},
        tsserver = {},
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
        -- golangci_lint_ls = {},
        lua_ls = {
          settings = {
            Lua = {
              hint = {
                enable = true, -- necessary
              },
              diagnostics = {
                globals = { 'ngx', '_G' }
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
    },
    config = function(_, opts)
      -- opts.capabilities = require('cmp_nvim_lsp').default_capabilities()
      for server, opt in pairs(opts.servers) do
        require('lspconfig')[server].setup(opt)
      end
    end
  },
  {
    enabled = true,
    "garymjr/nvim-snippets",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    event = 'InsertEnter',
    opts = {
      friendly_snippets = true,
    },
  },
  {
    enabled = true,
    'hrsh7th/nvim-cmp',
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    event = 'InsertEnter',
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'snippets' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })
    end
  },
}
