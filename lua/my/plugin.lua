vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

vim.schedule(function()
  require('mini.diff').setup()
  require('mini.files').setup()
  require('mini.git').setup()
  require('mini.surround').setup()
  require('mini.pairs').setup()
  require('mini.icons').setup()
  require('mini.statusline').setup()

  require('mini.pick').setup()
  require('mini.extra').setup()

  MiniPick.registry.projects = function()
    local cwd = vim.fn.expand('~/git')
    local choose = function(item)
      vim.schedule(function() MiniPick.builtin.files(nil, { source = { cwd = item.path } }) end)
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end

  MiniPick.registry.smart_files = function()
    local show_with_icons = function(buf_id, items, query) MiniPick.default_show(buf_id, items, query,
        { show_icons = true }) end
    local cmd = { 'rg', '--files', '--color=never', '--sortr=modified' }
    local cur_file = vim.fn.expand('%:t')
    if cur_file ~= '' then table.insert(cmd, '--glob=!' .. cur_file) end
    return MiniPick.builtin.cli({ command = cmd }, { source = { show = show_with_icons } })
  end

  -- lsp config
  vim.diagnostic.config({ virtual_text = true })

  vim.lsp.config('*', {
    root_markers = { '.git' },
  })
  vim.lsp.config('jsonls', { cmd = { 'vscode-json-language-server', '--stdio' }, filetypes = { 'json' } })
  vim.lsp.config('tsls',
    { cmd = { 'typescript-language-server', '--stdio' }, filetypes = { 'javascript', 'typescript' } })
  vim.lsp.config('yamls', { cmd = { 'yaml-language-server', '--stdio' }, filetypes = { 'yaml' } })
  vim.lsp.enable({ 'luals', 'gopls', 'tsls', 'jsonls', 'copilot' })

  require('nvim-treesitter').install { 'go', 'markdown', 'markdown_inline', 'javascript', 'typescript', 'json', 'yaml', 'lua' }
  require('nvim-treesitter').setup({
    ensure_installed = { 'lua', 'go', 'javascript', 'typescript', 'json', 'yaml', 'markdown', 'markdown_inline' },
    highlight = { enable = true },
  })
end)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
      vim.keymap.set(
        'i',
        '<tab>',
        vim.lsp.inline_completion.get,
        { desc = 'LSP: accept inline completion', buffer = bufnr }
      )
      vim.keymap.set(
        'i',
        '<C-l>',
        vim.lsp.inline_completion.select,
        { desc = 'LSP: switch inline completion', buffer = bufnr }
      )
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

vim.api.nvim_create_user_command('Gcd', 'silent tcd %:h | silent tcd `git root` | pwd', {})
vim.api.nvim_create_user_command('CopyName', ':let @+ = expand("%:p")', {})
vim.api.nvim_create_user_command('JJ', 'silent tabfirst | silent edit ~/Documents/note/tmp.md | silent tcd %:h', {})
vim.api.nvim_create_user_command('SSH', function(opts)
  local ssh_cmd = "ssh " .. opts.args
  vim.cmd("tabnew | terminal " .. ssh_cmd)
  vim.cmd([[startinsert]])
end, {
  nargs = '+',
  complete = 'file',
  desc = "ssh to host in new tab",
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

vim.api.nvim_create_autocmd({ 'TabNew' }, {
  pattern = "*",
  callback = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      once = true,
      callback = function()
        vim.cmd("silent! Gcd")
      end
    })
  end
})
