vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/zbirenbaum/copilot.lua' },
  -- { src = 'https://github.com/saghen/blink.cmp' },
  -- { src = 'https://github.com/rafamadriz/friendly-snippets' },
  -- { src = 'https://github.com/fishioon/cmd.nvim' },
})

vim.schedule(function()
  require('mini.diff').setup()
  require('mini.files').setup()
  require('mini.git').setup()
  require('mini.surround').setup()
  require('mini.pairs').setup()
  require('mini.icons').setup()

  -- pick
  require('mini.pick').setup()
  require('mini.extra').setup()
  -- -@diagnostic disable: undefined-global
  MiniPick.registry.projects = function()
    local cwd = vim.fn.expand('~/git')
    local choose = function(item)
      vim.schedule(function() MiniPick.builtin.files(nil, { source = { cwd = item.path } }) end)
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end

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

  -- require('blink.cmp').setup({
  --   keymap = { preset = 'enter' },
  --   completion = { documentation = { auto_show = true } },
  --   cmdline = {
  --     keymap = { preset = 'cmdline' },
  --     completion = { menu = { auto_show = true } },
  --   },
  --   sources = {
  --     default = { 'lsp', 'path', 'snippets', 'buffer' },
  --   },
  --   fuzzy = { implementation = "prefer_rust_with_warning" },
  -- })

  -- lsp config
  vim.diagnostic.config({ virtual_text = true })
  vim.lsp.config('*', {
    root_markers = { '.git' },
  })
  vim.lsp.config('jsonls', { cmd = { 'vscode-json-languageserver', '--stdio' }, filetypes = { 'json' } })
  vim.lsp.config('tsls',
    { cmd = { 'typescript-language-server', '--stdio' }, filetypes = { 'javascript', 'typescript' } })
  vim.lsp.config('yamls', { cmd = { 'yaml-language-server', '--stdio' }, filetypes = { 'yaml' } })
  vim.lsp.enable({ 'luals', 'gopls', 'tsls' })

  require('nvim-treesitter').install { 'go', 'markdown', 'markdown_inline', 'javascript', 'typescript', 'json', 'yaml', 'lua' }
  require('nvim-treesitter').setup({
    ensure_installed = { 'lua', 'go', 'javascript', 'typescript', 'json', 'yaml', 'markdown', 'markdown_inline' },
    highlight = { enable = true },
  })
end)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    -- if not client:supports_method('textDocument/willSaveWaitUntil')
    --     and client:supports_method('textDocument/formatting') then
    --   vim.api.nvim_create_autocmd('BufWritePre', {
    --     group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
    --     buffer = args.buf,
    --     callback = function()
    --       vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
    --     end,
    --   })
    -- end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'lua', 'javascript', 'yaml', 'helm', 'json' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'lua', 'go', 'json' },
  callback = function() vim.treesitter.start() end,
})

-- -@diagnostic disable-next-line: param-type-mismatch
vim.api.nvim_create_autocmd('TabNewEntered', {
  pattern = "*",
  callback = function()
    vim.cmd("silent! Gcd")
  end
})

vim.api.nvim_create_user_command('Gcd', 'silent tcd %:h | silent tcd `git root` | pwd', {})
vim.api.nvim_create_user_command('CopyName', ':let @+ = expand("%:p")', {})
vim.api.nvim_create_user_command('JJ', 'silent tabfirst | silent edit ~/Documents/note/tmp.md | silent tcd %:h', {})

vim.api.nvim_create_user_command('SSH', function(opts)
  local ssh_cmd = "ssh " .. opts.args
  vim.cmd("tabnew | terminal " .. ssh_cmd)
  vim.cmd([[startinsert]])
end, {
  nargs = '+',       -- 接受至少一个参数
  complete = 'file', -- 路径自动补全
  desc = "在新标签页执行 SSH 连接"
})
