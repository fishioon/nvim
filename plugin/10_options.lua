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
vim.o.foldlevel      = 99
vim.o.tabstop        = 4
vim.o.cmdheight      = 0

vim.diagnostic.config({
  virtual_text = { current_line = true, severity = { min = "INFO", max = "WARN" } },
  virtual_lines = { current_line = true, severity = { min = "ERROR" } },
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

vim.lsp.enable({ 'luals', 'gopls', 'jsonls', 'tsls' })

vim.api.nvim_set_hl(0, 'SnacksPickerDir', {
  link = 'Comment',
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    -- Enable auto-completion.
    -- if client:supports_method('textDocument/completion') then
    --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    -- end

    if client:supports_method('textDocument/documentColor') then
      vim.lsp.document_color.enable(true, args.buf)
    end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

-- vim.cmd('colorscheme kanagawa')
