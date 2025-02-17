vim.api.nvim_create_user_command('Gcd', 'silent tcd %:h | silent tcd `git root`', {})
vim.api.nvim_create_user_command('CopyName', ':let @+ = expand("%:p")', {})
vim.api.nvim_create_user_command('JJ', 'silent tabfirst | silent edit ~/Documents/note/tmp.md | silent tcd %:h', {})

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = { "*/templates/*.yaml", "*/templates/*.tpl", "*.gotmpl", "helmfile*.yaml" },
--   callback = function()
--     vim.bo.filetype = "helm"
--   end,
-- })

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'c', 'lua', 'javascript', 'yaml', 'helm' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})


vim.api.nvim_create_autocmd("TabNew", {
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

vim.keymap.set('n', '<D-s>', '<Cmd>silent! update<CR>')
vim.keymap.set('i', '<D-s>', '<Esc><Cmd>silent! update<CR>')
vim.keymap.set('t', '<D-s>', '<C-\\><C-N>')

vim.keymap.set('v', '<leader>y', '"+y')
nmap_leader('y', '"+Y', "Yank line to system clipboard")
nmap_leader('n', '<C-w>gf<cr>')
nmap_leader('ss', ':wa | mksession! ~/.config/work.vim<cr>')
nmap_leader('so', ':so ~/.config/work.vim<cr>')

-- nmap_leader('db', function() Snacks.bufdelete() end, "Delete buffer")
nmap_leader('d', '<cmd>Gcd<cr>', "Change directory to git root")
nmap_leader('D', '<cmd>silent tcd %:h<cr>', "Change directory to file dir")

-- lsp
nmap_leader('=', ':lua vim.lsp.buf.format({async=true})<cr>')

-- cmd.nvim
nmap_leader('r', function()
  local cmd = require('cmd').cmd()
  require('term').send(cmd .. '\n', false)
end)

nmap_leader('eo', function()
  local cmd = require('cmd').cmd()
  local output = vim.fn.systemlist(cmd)
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, output)
end)

nmap_leader('ey', function()
  local cmd = require('cmd').cmd()
  vim.fn.setreg('+', cmd)
end)

-- just like vscode shortcuts
-- vim.keymap.set({ 'n', 't' }, '<D-j>', function() require('term').toggle() end)
vim.keymap.set({ 'n', 't' }, '<C-/>', function() require('term').toggle() end)

local leader_keys = {
  -- most use key
  { "<space>", function() Snacks.picker.files() end,                                   "Find Files" },
  { ",",       function() Snacks.picker.buffers({ filter = { cwd = true } }) end,      "Buffers" },
  { "/",       function() Snacks.picker.grep() end,                                    "Grep" },
  { ";",       function() Snacks.picker.command_history() end,                         "Command History" },
  { "n",       '<C-w>gf<cr>',                                                          "New tab with under file" },
  { "y",       '"+y',                                                                  "Yank line to system clipboard" },
  { "d",       '<cmd>Gcd<cr>',                                                         "Change directory to git root" },
  { "D",       '<cmd>silent tcd %:h<cr>',                                              "Change directory to file dir" },

  -- session
  { "ss",      ':wa | mksession! ~/.config/work.vim<cr>',                              "Save session" },
  { "so",      ':so ~/.config/work.vim<cr>',                                           "Open session" },

  -- normal
  { 'gg',      function() Snacks.lazygit() end,                                        'Lazygit' },
  -- snacks picker
  { "fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, "Find Config File" },
  { "fg",      function() Snacks.picker.git_files() end,                               "Find Git Files" },
  { "fr",      function() Snacks.picker.recent() end,                                  "Recent" },
  { "gc",      function() Snacks.picker.git_log() end,                                 "Git Log" },
  { "gs",      function() Snacks.picker.git_status() end,                              "Git Status" },
  { "fb",      function() Snacks.picker.lines() end,                                   "Buffer Lines" },
  { "fB",      function() Snacks.picker.grep_buffers() end,                            "Grep Open Buffers" },
  { "fw",      function() Snacks.picker.grep_word() end,                               "Visual selection or word",     mode = { "n", "x" } },
  { 'f"',      function() Snacks.picker.registers() end,                               "Registers" },
  { "fa",      function() Snacks.picker.autocmds() end,                                "Autocmds" },
  { "fC",      function() Snacks.picker.commands() end,                                "Commands" },
  { "fd",      function() Snacks.picker.diagnostics() end,                             "Diagnostics" },
  { "fh",      function() Snacks.picker.help() end,                                    "Help Pages" },
  { "fH",      function() Snacks.picker.highlights() end,                              "Highlights" },
  { "fj",      function() Snacks.picker.jumps() end,                                   "Jumps" },
  { "fk",      function() Snacks.picker.keymaps() end,                                 "Keymaps" },
  { "fl",      function() Snacks.picker.loclist() end,                                 "Location List" },
  { "fM",      function() Snacks.picker.man() end,                                     "Man Pages" },
  { "fm",      function() Snacks.picker.marks() end,                                   "Marks" },
  { "fR",      function() Snacks.picker.resume() end,                                  "Resume" },
  { "fq",      function() Snacks.picker.qflist() end,                                  "Quickfix List" },
  { "fC",      function() Snacks.picker.colorschemes() end,                            "Colorschemes" },
  { "fp",      function() Snacks.picker.projects() end,                                "Projects" },
  { "fe",      function() Snacks.picker.explorer() end,                                "explorer" },


}

for _, key in ipairs(leader_keys) do
  local mode = key.mode or { "n" }
  for _, m in ipairs(mode) do
    vim.keymap.set(m, '<Leader>' .. key[1], key[2], { desc = key[3], nowait = key.nowait })
  end
end
