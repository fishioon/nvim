vim.api.nvim_create_user_command('Gcd', 'silent tcd %:h | silent tcd `git root`', {})
vim.api.nvim_create_user_command('JJ', ':tabfirst | edit ~/Documents/note/tmp.md |tcd %:h', {})
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'c', 'lua' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

local function keymap_nt(lhs, rhs, opt)
  vim.keymap.set('n', lhs, rhs, opt)
  vim.keymap.set('t', lhs, '<C-\\><C-N>' .. rhs, opt)
  vim.keymap.set('i', lhs, '<Esc>' .. rhs, opt)
end
--

local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end
local xmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, opts)
end

-- Better command history navigation
vim.keymap.set('c', '<C-p>', '<Up>', { silent = false })
vim.keymap.set('c', '<C-n>', '<Down>', { silent = false })

keymap_nt('<D-0>', ':silent tablast<CR>')
keymap_nt('<D-1>', '1gt')
keymap_nt('<D-2>', '2gt')
keymap_nt('<D-3>', '3gt')
keymap_nt('<D-4>', '4gt')
keymap_nt('<D-D>', ':vsplit|terminal<cr>')
keymap_nt('<D-[>', '<C-w>W')
keymap_nt('<D-]>', '<C-w>w')
keymap_nt('<D-d>', ':split|terminal<cr>')
keymap_nt('<S-D-{>', 'gT')
keymap_nt('<S-D-}>', 'gt')

vim.keymap.set('n', '<D-s>', '<Cmd>silent! update<CR>', { desc = "Save file" })
vim.keymap.set('i', '<D-s>', '<Esc><Cmd>silent! update<CR>', { desc = "Save file" })
vim.keymap.set('t', '<D-s>', '<C-\\><C-N>', { desc = "Exit terminal mode" })
vim.keymap.set('v', '<space>y', '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set('n', '<space>y', '"+Y', { desc = "Yank line to system clipboard" })
vim.keymap.set('v', '<D-c>', '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set('n', '<D-c>', '"+Y', { desc = "Copy line to system clipboard" })

vim.keymap.set('n', '<space>n', '<C-w>gf:Gcd<cr>')
vim.keymap.set('n', '<space>ss', ':wa | mksession! ~/.config/work.vim<cr>')
vim.keymap.set('n', '<space>so', ':so ~/.config/work.vim<cr>')
vim.keymap.set('n', '<space><space>', ':JJ<cr>', { silent = true })
vim.keymap.set('n', '<space>d', '<cmd>Gcd<cr>')

-- lsp
vim.keymap.set('n', '<space>=', ':lua vim.lsp.buf.format({async=true})<cr>')
vim.keymap.set('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<cr>')

vim.keymap.set('n', '<space>gg', function()
  require('float_term').float_term('lazygit', {
    size = { width = 0.85, height = 0.8 },
  })
end)

-- cmd.nvim
vim.keymap.set('n', '<space>ee', function()
  local cmd = require('cmd').cmd()
  require('term').send(cmd .. '\n', false)
end)

vim.keymap.set('n', '<space>eo', function()
  local cmd = require('cmd').cmd()
  local output = vim.fn.systemlist(cmd)
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, output)
end)

vim.keymap.set('n', '<space>ey', function()
  local cmd = require('cmd').cmd()
  vim.fn.setreg('+', cmd)
end)
vim.keymap.set({ 'n', 't' }, '<D-j>', function() require('term').toggle() end)

-- mini.nvim
-- git
vim.keymap.set('n', '<space>gs', function() MiniGit.show_at_cursor() end)
-- vim.keymap.set('n', '<space>o', function() MiniFiles.open() end)

-- picker
vim.keymap.set('n', '<space>ff', '<cmd>Pick files<cr>')
vim.keymap.set('n', '<space>b', '<cmd>Pick buffers<cr>')
vim.keymap.set('n', '<space>fg', '<cmd>Pick grep_live<cr>')
vim.keymap.set('n', '<space>/', '<cmd>Pick grep<cr>')
vim.keymap.set('n', '<space>p', '<cmd>Pick resume<cr>')
vim.keymap.set('n', '<space>w', function()
  MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
end)
