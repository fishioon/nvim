if _G.Config == nil then _G.Config = {} end
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

local function keymap_all(lhs, rhs, opt)
  vim.keymap.set('t', lhs, '<C-\\><C-N>' .. rhs, opt)
  vim.keymap.set('i', lhs, '<Esc>' .. rhs, opt)
  vim.keymap.set('n', lhs, rhs, opt)
end

for i = 1, 9 do
  vim.keymap.set('n', '<space>' .. i, i .. 'gt', { desc = 'Go to tab ' .. i })
end
-- keymap_all('<leader>0', '<CMD>tablast<CR>')
-- keymap_all('<M-0>', '<CMD>tablast<CR>')

keymap_all('<C-j>', '<C-w>w')
keymap_all('<C-k>', '<C-w>W')

vim.keymap.set('n', '<D-s>', '<Cmd>silent! write<CR>')
vim.keymap.set('i', '<D-s>', '<Esc><Cmd>silent! update<CR>')
vim.keymap.set('t', '<D-s>', '<C-\\><C-N>')

-- nmap_leader('db', function() Snacks.bufdelete() end, "Delete buffer")
nmap_leader('d', '<cmd>Gcd<cr>', "Change directory to git root")
nmap_leader('D', '<cmd>silent tcd %:h<cr>', "Change directory to file dir")

-- lsp
-- vim.keymap.set('n', '<Leader>=', '<CMD>silent! lua vim.lsp.buf.format({async=true})<cr>')
-- just like vscode shortcuts
-- vim.keymap.set({ 'n', 't' }, '<D-j>', function() require('term').toggle() end)

vim.keymap.set('n', "<Leader>n", '<C-w>gf<cr>', { desc = "New tab with under file" })

vim.keymap.set({ 'v', 'x' }, '<D-c>', '"+y', { desc = 'MacOS copy' })
vim.keymap.set({ 'n', 'i' }, '<D-c>', '"+Y', { desc = 'MacOS copy' })
-- vim.keymap.set('v', '<leader>y', '"+y')
-- vim.keymap.set('n', "<Leader>y", '"+y', { desc = "Yank line to system clipboard" })
vim.keymap.set('n', "<Leader>d", '<cmd>Gcd<cr>', { desc = "Change directory to git root" })
vim.keymap.set('n', "<Leader>D", '<cmd>silent tcd %:h<cr>', { desc = "Change directory to file dir" })
vim.keymap.set('n', '<leader>=', 'gggqG')


-- Basic mappings =============================================================
-- NOTE: Most basic mappings come from 'mini.basics'

-- Shorter version of the most frequent way of going outside of terminal window
vim.keymap.set('t', '<C-h>', [[<C-\><C-N><C-w>h]])

-- Leader mappings ============================================================
-- stylua: ignore start

-- Create global tables with information about clue groups in certain modes
-- Structure of tables is taken to be compatible with 'mini.clue'.
-- Create `<Leader>` mappings
-- b is for 'buffer'
nmap_leader('ba', '<Cmd>b#<CR>', 'Alternate')
nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>', 'Delete')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>', 'Delete!')
nmap_leader('bs', '<Cmd>lua Config.new_scratch_buffer()<CR>', 'Scratch')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', 'Wipeout')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout!')

-- e is for 'explore' and 'edit'
local edit_config_file = function(filename)
  return '<Cmd>edit ' .. vim.fn.stdpath('config') .. '/lua/my/' .. filename .. '<CR>'
end
nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>', 'Directory')
nmap_leader('ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', 'File directory')
nmap_leader('ec', edit_config_file(''), 'neovim config')
nmap_leader('ek', edit_config_file('keymap.lua'), 'neovim config')
nmap_leader('es', '<Cmd>lua MiniSessions.select()<CR>', 'Sessions')
nmap_leader('eq', '<Cmd>lua Config.toggle_quickfix()<CR>', 'Quickfix')
vim.keymap.set({ 'n', 't' }, '<c-.>', function() Config.term_open(true) end, { desc = 'Toggle terminal' })
nmap_leader('cc', function() Config.term_open(true, 'claude', 'vsplit') end, 'Toggle claude')
nmap_leader('cx', function() Config.term_open(true, 'codex', 'vsplit') end, 'Toggle codex')
nmap_leader('ss', function() Config.term_exec() end, 'Toggle terminal command')

-- f is for 'fuzzy find'
-- nmap_leader(' ',  '<Cmd>Pick buffers<CR>', 'Buffers')
nmap_leader(' ', function()
  MiniPick.builtin.buffers(nil, {
    mappings = {
      wipeout = {
        char = '<C-d>',
        func = function() vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {}) end,
      }
    }
  })
end, 'Buffers')
nmap_leader('/', '<Cmd>Pick grep_live<CR>', 'Grep live')
nmap_leader(';', '<Cmd>Pick history scope=":"<CR>', '":" history')
nmap_leader('f/', '<Cmd>Pick history scope="/"<CR>', '"/" history')
nmap_leader('f:', '<Cmd>Pick history scope=":"<CR>', '":" history')
nmap_leader('f;', '<Cmd>Pick history scope=":"<CR>', '":" history')
nmap_leader('fa', '<Cmd>Pick git_hunks scope="staged"<CR>', 'Added hunks (all)')
nmap_leader('fA', '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', 'Added hunks (current)')
nmap_leader('fb', '<Cmd>Pick buffers<CR>', 'Buffers')
nmap_leader('fc', '<Cmd>Pick git_commits<CR>', 'Commits (all)')
nmap_leader('fC', '<Cmd>Pick git_commits path="%"<CR>', 'Commits (current)')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="all"<CR>', 'Diagnostic workspace')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
nmap_leader('ff', '<Cmd>Pick files<CR>', 'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
nmap_leader('fw', '<Cmd>Pick grep pattern="<cword>"<CR>', 'Grep current word')
nmap_leader('fG', '<Cmd>Pick grep pattern="<cword>"<CR>', 'Grep current word')
nmap_leader('fh', '<Cmd>Pick help<CR>', 'Help tags')
nmap_leader('fH', '<Cmd>Pick hl_groups<CR>', 'Highlight groups')
nmap_leader('fl', '<Cmd>Pick buf_lines scope="all"<CR>', 'Lines (all)')
nmap_leader('fL', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (current)')
nmap_leader('fm', '<Cmd>Pick git_hunks<CR>', 'Modified hunks (all)')
nmap_leader('fM', '<Cmd>Pick git_hunks path="%"<CR>', 'Modified hunks (current)')
nmap_leader('fr', '<Cmd>Pick resume<CR>', 'Resume')
nmap_leader('fp', '<Cmd>Pick projects<CR>', 'Projects')
nmap_leader('fR', '<Cmd>Pick lsp scope="references"<CR>', 'References (LSP)')
nmap_leader('fs', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace (LSP)')
nmap_leader('fS', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols buffer (LSP)')
nmap_leader('fv', '<Cmd>Pick visit_paths cwd=""<CR>', 'Visit paths (all)')
nmap_leader('fV', '<Cmd>Pick visit_paths<CR>', 'Visit paths (cwd)')

-- g is for git
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
nmap_leader('ga', '<Cmd>Git diff --cached<CR>', 'Added diff')
nmap_leader('gA', '<Cmd>Git diff --cached -- %<CR>', 'Added diff buffer')
nmap_leader('gc', '<Cmd>Git commit<CR>', 'Commit')
nmap_leader('gC', '<Cmd>Git commit --amend<CR>', 'Commit amend')
nmap_leader('gd', '<Cmd>Git diff<CR>', 'Diff')
nmap_leader('gD', '<Cmd>Git diff -- %<CR>', 'Diff buffer')
nmap_leader('gg', '<Cmd>lua Config.open_lazygit()<CR>', 'Git tab')
nmap_leader('gl', '<Cmd>' .. git_log_cmd .. '<CR>', 'Log')
nmap_leader('gL', '<Cmd>' .. git_log_cmd .. ' --follow -- %<CR>', 'Log buffer')
nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Toggle overlay')
nmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at cursor')

xmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at selection')

-- L is for 'Lua'
nmap_leader('Lc', '<Cmd>lua Config.log_clear()<CR>', 'Clear log')
nmap_leader('LL', '<Cmd>luafile %<CR><Cmd>echo "Sourced lua"<CR>', 'Source buffer')
nmap_leader('Ls', '<Cmd>lua Config.log_print()<CR>', 'Show log')
nmap_leader('Lx', '<Cmd>lua Config.execute_lua_line()<CR>', 'Execute `lua` line')

-- m is for 'map'
nmap_leader('mc', '<Cmd>lua MiniMap.close()<CR>', 'Close')
nmap_leader('mf', '<Cmd>lua MiniMap.toggle_focus()<CR>', 'Focus (toggle)')
nmap_leader('mo', '<Cmd>lua MiniMap.open()<CR>', 'Open')
nmap_leader('mr', '<Cmd>lua MiniMap.refresh()<CR>', 'Refresh')
nmap_leader('ms', '<Cmd>lua MiniMap.toggle_side()<CR>', 'Side (toggle)')
nmap_leader('mt', '<Cmd>lua MiniMap.toggle()<CR>', 'Toggle')

vim.keymap.set('n', '<C-W>:', function()
  vim.ui.input({
    prompt = '(capture) :',
    completion = 'command',
  }, function(input)
    if input == '' or input == nil then return end
    local output = vim.api.nvim_exec2(input, { output = true }).output
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n'))
    local _ = vim.api.nvim_open_win(buf, true, {
      height = vim.o.cmdwinheight,
      split = 'below',
      win = 0,
    })
  end)
end)
