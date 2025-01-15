vim.api.nvim_create_user_command('Gcd', 'silent tcd %:h | silent tcd `git root`', {})
vim.api.nvim_create_user_command('CopyName', ':let @+ = expand("%:p")', {})
vim.api.nvim_create_user_command('JJ', ':tabfirst | edit ~/Documents/note/tmp.md |tcd %:h', {})
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'c', 'lua', 'javascript' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/templates/*.yaml", "*/templates/*.tpl", "*.gotmpl", "helmfile*.yaml" },
  callback = function()
    vim.bo.filetype = "helm"
  end,
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
local xmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, opts)
end

for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, i .. 'gt')
end
nmap_leader('0', '<CMD>tablast<CR>')

nmap_leader('q', '<CMD>wqall<CR>')

keymap_all('<C-j>', '<C-w>w')
keymap_all('<C-k>', '<C-w>W')

vim.keymap.set('n', '<D-s>', '<Cmd>silent! update<CR>')
vim.keymap.set('i', '<D-s>', '<Esc><Cmd>silent! update<CR>')
vim.keymap.set('t', '<D-s>', '<C-\\><C-N>')

vim.keymap.set('v', '<leader>y', '"+y')
nmap_leader('y', '"+Y', "Yank line to system clipboard")
nmap_leader('n', '<C-w>gf:Gcd<cr>')
nmap_leader('ss', ':wa | mksession! ~/.config/work.vim<cr>')
nmap_leader('so', ':so ~/.config/work.vim<cr>')
nmap_leader('<leader>', ':JJ<cr>', 'Open tmp.md in first tab', { silent = true })

-- nmap_leader('db', function() Snacks.bufdelete() end, "Delete buffer")
nmap_leader('d', '<cmd>Gcd<cr>', "Change directory to git root")
nmap_leader('D', '<cmd>silent tcd %:h<cr>', "Change directory to file dir")

nmap_leader('q', '<cmd>lua Config.toggle_quickfix()<cr>', "Toggle quickfix")

-- lsp
nmap_leader('=', ':lua vim.lsp.buf.format({async=true})<cr>')

nmap_leader('gg', function()
  require('float_term').float_term('lazygit', {
    size = { width = 0.85, height = 0.8 },
  })
end)

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
vim.keymap.set({ 'n', 't' }, '<D-j>', function() require('term').toggle() end)
vim.keymap.set({ 'n', 't' }, '<C-/>', function() require('term').toggle() end)

-- mini.nvim
-- git
nmap_leader('gs', function() MiniGit.show_at_cursor() end)
-- nmap_leader('o', function() MiniFiles.open() end)

-- e is for 'explore' and 'edit'
nmap_leader('ec', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("config"))<CR>', 'Config')
nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>', 'Directory')
nmap_leader('ee', '<Cmd>lua MiniFiles.open("~/work/alb")<CR>', 'Gitlab repos')
nmap_leader('ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', 'File directory')
nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>', 'My vimrc')
nmap_leader('em', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("data").."/site/pack/deps/start/mini.nvim")<CR>',
  'Mini.nvim directory')
nmap_leader('ep', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("data").."/site/pack/deps/opt")<CR>', 'Plugins directory')
nmap_leader('eq', '<Cmd>lua Config.toggle_quickfix()<CR>', 'Quickfix')

-- f is for 'fuzzy find'
-- nmap_leader('f/', '<Cmd>Pick history scope="/"<CR>', '"/" history')
-- nmap_leader('f;', '<Cmd>Pick history scope=":"<CR>', '":" history')
-- nmap_leader('fa', '<Cmd>Pick git_hunks scope="staged"<CR>', 'Added hunks (all)')
-- nmap_leader('fA', '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', 'Added hunks (current)')
-- nmap_leader('fb', '<Cmd>Pick buffers<CR>', 'Buffers')
-- nmap_leader('b', '<Cmd>Pick buffers_cwd<CR>', 'Buffers scope="current"')
--
-- nmap_leader('fc', '<Cmd>Pick git_commits<CR>', 'Commits (all)')
-- nmap_leader('fC', '<Cmd>Pick git_commits path="%"<CR>', 'Commits (current)')
-- nmap_leader('fd', '<Cmd>Pick diagnostic scope="all"<CR>', 'Diagnostic workspace')
-- nmap_leader('fD', '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
-- nmap_leader('ff', '<Cmd>Pick files<CR>', 'Files')
-- nmap_leader('fg', '<Cmd>Pick grep<CR>', 'Grep')
-- nmap_leader('fw', '<Cmd>Pick grep pattern="<cword>"<CR>', 'Grep current word')
-- nmap_leader('/', '<Cmd>Pick grep_live<CR>', 'Grep live')
-- nmap_leader('fh', '<Cmd>Pick help<CR>', 'Help tags')
-- nmap_leader('fH', '<Cmd>Pick hl_groups<CR>', 'Highlight groups')
-- nmap_leader('fl', '<Cmd>Pick buf_lines scope="all"<CR>', 'Lines (all)')
-- nmap_leader('fL', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (current)')
-- nmap_leader('fm', '<Cmd>Pick git_hunks<CR>', 'Modified hunks (all)')
-- nmap_leader('fM', '<Cmd>Pick git_hunks path="%"<CR>', 'Modified hunks (current)')
-- nmap_leader('fp', '<Cmd>Pick projects<CR>', 'Projects')
-- nmap_leader('fr', '<Cmd>Pick resume<CR>', 'Resume')
-- nmap_leader('fR', '<Cmd>Pick lsp scope="references"<CR>', 'References (LSP)')
-- nmap_leader('fs', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace (LSP)')
-- nmap_leader('fS', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols buffer (LSP)')
-- nmap_leader('fv', '<Cmd>Pick visit_paths cwd=""<CR>', 'Visit paths (all)')
-- nmap_leader('fV', '<Cmd>Pick visit_paths<CR>', 'Visit paths (cwd)')

-- g is for git
nmap_leader('ga', '<Cmd>Git add %<CR>', 'git add')
nmap_leader('gc', '<Cmd>Git commit<CR>', 'Commit')
nmap_leader('gC', '<Cmd>Git commit --amend<CR>', 'Commit amend')
-- nmap_leader('gg', '<Cmd>lua Config.open_lazygit()<CR>', 'Git tab')
-- nmap_leader('gl', '<Cmd>Git log --oneline<CR>', 'Log')
-- nmap_leader('gL', '<Cmd>Git log --oneline --follow -- %<CR>', 'Log buffer')
--
nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Toggle overlay')
nmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at cursor')

-- snacks
nmap_leader('z', function() Snacks.zen() end, 'Toggle Zen Mode')
nmap_leader('Z', function() Snacks.zen.zoom() end, 'Toggle Zen Mode')
nmap_leader('.', function() Snacks.scratch() end, 'Toggle Scratch Buffer')
nmap_leader('S', function() Snacks.scratch.select() end, 'Select Scratch Buffer')

-- nmap_leader('gB', function() Snacks.gitbrowse() end, 'Git Browse')
-- nmap_leader('gb', function() Snacks.git.blame_line() end, 'Git Blame line')
nmap_leader('gg', function() Snacks.lazygit() end, 'Lazygit')
-- nmap_leader('gl', function() Snacks.lazygit.log() end, 'Lazygit log (cwd)')
-- nmap_leader('gf', function() Snacks.lazygit.log_file() end, 'Lazygit current file history')

-- { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
-- { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
vim.keymap.set('n', '[[', function() MiniGit.show_at_cursor() end)

xmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at selection')

local keys = {
  { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
  { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
  { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
  { "<leader><space>", function() Snacks.picker.files() end,                                   desc = "Find Files" },
  -- find
  { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
  { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
  { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
  { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
  { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
  -- git
  { "<leader>gc",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
  { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
  -- Grep
  { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
  { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
  { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
  { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
  -- search
  { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
  { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
  { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
  { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
  { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
  { "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
  { "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
  { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
  { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
  { "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
  { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
  { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
  { "<leader>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
  { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
  { "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
  { "<leader>qp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
  -- LSP
  { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
  { "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
  { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
  { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
  { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
}

for _, key in ipairs(keys) do
  local mode = key.mode or { "n" }
  for _, m in ipairs(mode) do
    vim.keymap.set(m, key[1], key[2], { desc = key.desc, nowait = key.nowait })
  end
end
