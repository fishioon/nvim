vim.api.nvim_create_user_command('Gcd', 'silent tcd %:h | silent tcd `git root` | pwd', {})
vim.api.nvim_create_user_command('CopyName', ':let @+ = expand("%:p")', {})
vim.api.nvim_create_user_command('JJ', 'silent tabfirst | silent edit ~/Documents/note/tmp.md | silent tcd %:h', {})

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = { "*/templates/*.yaml", "*/templates/*.tpl", "*.gotmpl", "helmfile*.yaml" },
--   callback = function()
--     vim.bo.filetype = "helm"
--   end,
-- })

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'c', 'lua', 'javascript', 'yaml', 'helm', 'json' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_autocmd({ 'TabNew' }, {
  pattern = "*",
  callback = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      once = true, -- 只执行一次，避免影响其他 BufEnter 事件
      callback = function()
        vim.cmd("silent! Gcd")
      end
    })
  end
})

local function keymap_all(lhs, rhs, opt)
  vim.keymap.set('n', lhs, rhs, opt)
  vim.keymap.set('t', lhs, '<C-\\><C-N>' .. rhs, opt)
  -- vim.keymap.set('i', lhs, '<Esc>' .. rhs, opt)
end
--

local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end

for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, i .. 'gt')
end
vim.keymap.set('n', '<leader>0', '<CMD>tablast<CR>')

keymap_all('<C-j>', '<C-w>w')
keymap_all('<C-k>', '<C-w>W')

vim.keymap.set('n', '<D-s>', '<Cmd>silent! write<CR>')
vim.keymap.set('i', '<D-s>', '<Esc><Cmd>silent! update<CR>')
vim.keymap.set('t', '<D-s>', '<C-\\><C-N>')

nmap_leader('ss', ':wa | mksession! ~/.config/work/work.vim<cr>')
nmap_leader('so', ':so ~/.config/work/work.vim<cr>')

-- nmap_leader('db', function() Snacks.bufdelete() end, "Delete buffer")
nmap_leader('d', '<cmd>Gcd<cr>', "Change directory to git root")
nmap_leader('D', '<cmd>silent tcd %:h<cr>', "Change directory to file dir")

-- lsp
-- vim.keymap.set('n', '<Leader>=', '<CMD>silent! lua vim.lsp.buf.format({async=true})<cr>')
-- just like vscode shortcuts
-- vim.keymap.set({ 'n', 't' }, '<D-j>', function() require('term').toggle() end)

vim.keymap.set('n', "<Leader>n", '<C-w>gf<cr>', { desc = "New tab with under file" })
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', "<Leader>y", '"+y', { desc = "Yank line to system clipboard" })
vim.keymap.set('n', "<Leader>d", '<cmd>Gcd<cr>', { desc = "Change directory to git root" })
vim.keymap.set('n', "<Leader>D", '<cmd>silent tcd %:h<cr>', { desc = "Change directory to file dir" })

vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "i" }, "<D-l>", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
