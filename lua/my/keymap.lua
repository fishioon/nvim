vim.api.nvim_create_user_command('Gcd', 'silent tcd %:h | silent tcd `git root` | pwd', {})
vim.api.nvim_create_user_command('CopyName', ':let @+ = expand("%:p")', {})
vim.api.nvim_create_user_command('JJ', 'silent tabfirst | silent edit ~/Documents/note/tmp.md | silent tcd %:h', {})

vim.api.nvim_create_user_command('SSH', function(opts)
  local ssh_cmd = "ssh " .. opts.args
  vim.cmd("tabnew | terminal " .. ssh_cmd)
  vim.cmd([[startinsert]])
end, {
  nargs = '+',  -- 接受至少一个参数
  complete = 'file',  -- 路径自动补全
  desc = "在新标签页执行 SSH 连接"
})

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
  vim.keymap.set('i', lhs, '<Esc>' .. rhs, opt)
end
--

local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end

for i = 1, 9 do
  -- keymap_all('<leader>' .. i, i .. 'gt', { desc = 'Go to tab ' .. i })
  keymap_all('<A-' .. i .. '>', i .. 'gt', { desc = 'Go to tab ' .. i })
end
-- keymap_all('<leader>0', '<CMD>tablast<CR>')
keymap_all('<A-0>', '<CMD>tablast<CR>')

keymap_all('<C-j>', '<C-w>w')
keymap_all('<C-k>', '<C-w>W')

vim.keymap.set('n', '<D-s>', '<Cmd>silent! write<CR>')
vim.keymap.set('i', '<D-s>', '<Esc><Cmd>silent! update<CR>')
vim.keymap.set('t', '<D-s>', '<C-\\><C-N>')

-- nmap_leader('ss', ':wa | mksession! ~/.config/work/work.vim<cr>')
-- nmap_leader('so', ':so ~/.config/work/work.vim<cr>')

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
vim.keymap.set('n', '<leader>=', 'gggqG')


-- Basic mappings =============================================================
-- NOTE: Most basic mappings come from 'mini.basics'

-- Shorter version of the most frequent way of going outside of terminal window
vim.keymap.set('t', '<C-h>', [[<C-\><C-N><C-w>h]])

-- Paste before/after linewise
local cmd = vim.fn.has('nvim-0.12') == 1 and 'iput' or 'put'
vim.keymap.set({ 'n', 'x' }, '[p', '<Cmd>exe "' .. cmd .. '! " . v:register<CR>', { desc = 'Paste Above' })
vim.keymap.set({ 'n', 'x' }, ']p', '<Cmd>exe "' .. cmd .. ' "  . v:register<CR>', { desc = 'Paste Below' })

-- Leader mappings ============================================================
-- stylua: ignore start

-- Create global tables with information about clue groups in certain modes
-- Structure of tables is taken to be compatible with 'mini.clue'.
_G.Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>e', desc = '+Explore' },
  { mode = 'n', keys = '<Leader>f', desc = '+Find' },
  { mode = 'n', keys = '<Leader>g', desc = '+Git' },
  { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
  { mode = 'n', keys = '<Leader>L', desc = '+Lua/Log' },
  { mode = 'n', keys = '<Leader>m', desc = '+Map' },
  { mode = 'n', keys = '<Leader>o', desc = '+Other' },
  { mode = 'n', keys = '<Leader>r', desc = '+R' },
  { mode = 'n', keys = '<Leader>t', desc = '+Terminal/Minitest' },
  { mode = 'n', keys = '<Leader>T', desc = '+Test' },
  { mode = 'n', keys = '<Leader>v', desc = '+Visits' },

  { mode = 'x', keys = '<Leader>l', desc = '+LSP' },
  { mode = 'x', keys = '<Leader>r', desc = '+R' },
}

-- Create `<Leader>` mappings
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
nmap_leader('ec', edit_config_file('plugin.lua'), 'neovim config')
nmap_leader('es', '<Cmd>lua MiniSessions.select()<CR>', 'Sessions')
nmap_leader('eq', '<Cmd>lua Config.toggle_quickfix()<CR>', 'Quickfix')

-- f is for 'fuzzy find'
nmap_leader(' ', '<Cmd>Pick buffers<CR>', 'Buffers')
nmap_leader('/', '<Cmd>Pick grep_live<CR>', 'Grep live')
nmap_leader('f/', '<Cmd>Pick history scope="/"<CR>', '"/" history')
nmap_leader('f:', '<Cmd>Pick history scope=":"<CR>', '":" history')
nmap_leader('f;', '<Cmd>Pick history scope=":"<CR>', '":" history')
nmap_leader(';', '<Cmd>Pick history scope=":"<CR>', '":" history')
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

-- l is for 'LSP' (Language Server Protocol)
-- local formatting_cmd = '<Cmd>lua require("conform").format({ lsp_fallback = true })<CR>'
-- nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'Actions')
-- nmap_leader('ld', '<Cmd>lua vim.diagnostic.open_float()<CR>', 'Diagnostics popup')
-- nmap_leader('lf', formatting_cmd, 'Format')
-- nmap_leader('li', '<Cmd>lua vim.lsp.buf.hover()<CR>', 'Information')
-- nmap_leader('lj', '<Cmd>lua vim.diagnostic.goto_next()<CR>', 'Next diagnostic')
-- nmap_leader('lk', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', 'Prev diagnostic')
-- nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>', 'References')
-- nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>', 'Rename')
-- nmap_leader('ls', '<Cmd>lua vim.lsp.buf.definition()<CR>', 'Source definition')
-- xmap_leader('lf', formatting_cmd, 'Format selection')

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

-- o is for 'other'
local trailspace_toggle_command = '<Cmd>lua vim.b.minitrailspace_disable = not vim.b.minitrailspace_disable<CR>'
nmap_leader('oC', '<Cmd>lua MiniCursorword.toggle()<CR>', 'Cursor word hl toggle')
nmap_leader('od', '<Cmd>Neogen<CR>', 'Document')
nmap_leader('oh', '<Cmd>normal gxiagxila<CR>', 'Move arg left')
nmap_leader('oH', '<Cmd>TSBufToggle highlight<CR>', 'Highlight toggle')
nmap_leader('og', '<Cmd>lua MiniDoc.generate()<CR>', 'Generate plugin doc')
nmap_leader('ol', '<Cmd>normal gxiagxina<CR>', 'Move arg right')
nmap_leader('or', '<Cmd>lua MiniMisc.resize_window()<CR>', 'Resize to default width')
nmap_leader('oS', '<Cmd>lua Config.insert_section()<CR>', 'Section insert')
nmap_leader('ot', '<Cmd>lua MiniTrailspace.trim()<CR>', 'Trim trailspace')
nmap_leader('oT', trailspace_toggle_command, 'Trailspace hl toggle')
nmap_leader('oz', '<Cmd>lua MiniMisc.zoom()<CR>', 'Zoom toggle')

-- r is for 'R'
-- - Mappings starting with `T` send commands to current neoterm buffer, so
--   some sort of R interpreter should already run there
nmap_leader('rc', '<Cmd>T devtools::check()<CR>', 'Check')
nmap_leader('rC', '<Cmd>T devtools::test_coverage()<CR>', 'Coverage')
nmap_leader('rd', '<Cmd>T devtools::document()<CR>', 'Document')
nmap_leader('ri', '<Cmd>T devtools::install(keep_source=TRUE)<CR>', 'Install')
nmap_leader('rk', '<Cmd>T rmarkdown::render("%")<CR>', 'Knit file')
nmap_leader('rl', '<Cmd>T devtools::load_all()<CR>', 'Load all')
nmap_leader('rT', '<Cmd>T testthat::test_file("%")<CR>', 'Test file')
nmap_leader('rt', '<Cmd>T devtools::test()<CR>', 'Test')

-- - Copy to clipboard and make reprex (which itself is loaded to clipboard)
xmap_leader('rx', '"+y :T reprex::reprex()<CR>', 'Reprex selection')

-- s is for 'send' (Send text to neoterm buffer)
-- nmap_leader('s', '<Cmd>ToggleTermSendCurrentLine<CR>', 'Send to terminal')
vim.keymap.set({ 'n', 't' }, '<c-.>', function() require('term').toggle() end, { desc = 'Toggle terminal' })
vim.keymap.set('n', '<leader>ss', function()
  local command = require('cmd').cmd()
  require('term').send(command)
end,
{ desc = 'Run command with terminal' })

-- t is for 'terminal' (uses 'neoterm') and 'minitest'
nmap_leader('ta', '<Cmd>lua MiniTest.run()<CR>', 'Test run all')
nmap_leader('tf', '<Cmd>lua MiniTest.run_file()<CR>', 'Test run file')
nmap_leader('tl', '<Cmd>lua MiniTest.run_at_location()<CR>', 'Test run location')
nmap_leader('ts', '<Cmd>lua Config.minitest_screenshots.browse()<CR>', 'Test show screenshot')

-- T is for 'test'
nmap_leader('TF', '<Cmd>TestFile -strategy=make | copen<CR>', 'File (quickfix)')
nmap_leader('Tf', '<Cmd>TestFile<CR>', 'File')
nmap_leader('TL', '<Cmd>TestLast -strategy=make | copen<CR>', 'Last (quickfix)')
nmap_leader('Tl', '<Cmd>TestLast<CR>', 'Last')
nmap_leader('TN', '<Cmd>TestNearest -strategy=make | copen<CR>', 'Nearest (quickfix)')
nmap_leader('Tn', '<Cmd>TestNearest<CR>', 'Nearest')
nmap_leader('TS', '<Cmd>TestSuite -strategy=make | copen<CR>', 'Suite (quickfix)')
nmap_leader('Ts', '<Cmd>TestSuite<CR>', 'Suite')

-- v is for 'visits'
nmap_leader('vv', '<Cmd>lua MiniVisits.add_label("core")<CR>', 'Add "core" label')
nmap_leader('vV', '<Cmd>lua MiniVisits.remove_label("core")<CR>', 'Remove "core" label')
nmap_leader('vl', '<Cmd>lua MiniVisits.add_label()<CR>', 'Add label')
nmap_leader('vL', '<Cmd>lua MiniVisits.remove_label()<CR>', 'Remove label')

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
