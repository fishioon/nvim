local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = '<space>'
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.opt.background = 'dark'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'number'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 3
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
-- vim.opt.statusline =
-- "%<%f %{get(b:, 'gitsigns_status', '')} %h%m%r%=%{get(b:,'gitsigns_head','')} %{getcwd()} %-14.(%l,%c%V%) %P"

-- command
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'c', 'c++', 'javascript', 'lua', 'typescript', 'yaml', 'html', 'vim', 'json', 'nginx', 'proto', 'sh' },
  command = 'setlocal ts=2 sw=2 sts=2 expandtab',
})

vim.api.nvim_create_user_command('Gcd', 'silent lcd %:h | silent lcd `git root` | pwd', {})
vim.api.nvim_create_user_command('JJ', ':tabfirst | edit ~/Documents/note/tmp.md |lcd %:h', {})

-- global
vim.keymap.set('t', '<C-q>', '<C-\\><C-N>')
vim.keymap.set({ 'i', 'n' }, '<D-s>', '<ESC>:w<cr>')
-- vim.keymap.set('t', '<M-j>', '<C-\\><C-N><C-w>w')
-- vim.keymap.set('t', '<M-k>', '<C-\\><C-N><C-w>W')
-- vim.keymap.set('t', '<M-;>', '<C-\\><C-N>:')
-- vim.keymap.set('t', '<M-/>', '<C-\\><C-N>/')
-- vim.keymap.set('n', '<M-j>', '<C-w>w')
-- vim.keymap.set('n', '<M-k>', '<C-w>W')
-- vim.keymap.set('n', '<M-]>', 'gt')
-- vim.keymap.set('n', '<M-[>', 'gT')
-- vim.keymap.set('t', '<M-]>', '<C-\\><C-N>gt')
-- vim.keymap.set('t', '<M-[>', '<C-\\><C-N>gT')
-- vim.keymap.set('t', '<M-d>', '<C-\\><C-N>:split|terminal<cr>')
-- vim.keymap.set('t', '<M-D>', '<C-\\><C-N>:vsplit|terminal<cr>')
vim.keymap.set('v', '<space>y', '"+y')
vim.keymap.set('n', '<space>y', '"+Y')
vim.keymap.set('n', '<space>n', '<C-w>gf:Gcd<cr>')
vim.keymap.set('n', '<space>ss', ':wa | mksession! /tmp/session.vim<cr>')
vim.keymap.set('n', '<space>so', ':so /tmp/session.vim<cr>')
vim.keymap.set('n', '<space><space>', ':JJ<cr>', { silent = true })
vim.keymap.set('n', '<space>d', ':lcd %:h<cr>')

vim.keymap.set('n', '<space>gg', function()
  require('float_term').float_term('lazygit', {
    size = { width = 0.85, height = 0.8 },
  })
end)

require('lazy').setup("plugins", {
  rocks = {
    enabled = false,
  },
  dev = {
    path = '~/git',
  },
  change_detection = {
    notify = false,
  },
})

-- ./lua/plugins/lsp.lua
-- ./lua/plugins/plugins.lua
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({ async = true })
  end
})
