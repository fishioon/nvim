local now, later = MiniDeps.now, MiniDeps.later

now(function()
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end)

-- later(function() require('mini.ai').setup() end)
-- later(function() require('mini.animate').setup() end)
-- later(function() require('mini.cursorword').setup() end)
later(function() require('mini.diff').setup() end)
-- later(function() require('mini.extra').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.git').setup() end)
later(function() require('mini.pairs').setup() end)

-- later(function()
--   local switch_picker = function()
--     local query = MiniPick.get_picker_query() or {}
--     MiniPick.stop()
--     MiniPick.ui_select(vim.tbl_keys(MiniPick.registry), {
--       prompt = 'Switch picker with query: ' .. table.concat(query, ''),
--     }, function(picker)
--       vim.cmd('Pick ' .. picker)
--       local transfer_query = function() MiniPick.set_picker_query(query) end
--       vim.api.nvim_create_autocmd('User', { pattern = 'MiniPickStart', once = true, callback = transfer_query })
--     end)
--   end
--
--   require('mini.pick').setup({
--     window = {
--       config = { border = 'double' },
--     },
--     mappings = {
--       switch = { char = '<C-k>', func = switch_picker },
--     },
--   })
--
--   vim.ui.select = MiniPick.ui_select
--   vim.keymap.set('n', ',', [[<Cmd>Pick buf_lines scope='current' preserve_order=true<CR>]])
--
--   MiniPick.registry.projects = function()
--     local cwd = vim.fn.expand('~/repos')
--     local choose = function(item)
--       vim.schedule(function() MiniPick.builtin.files(nil, { source = { cwd = item.path } }) end)
--     end
--     return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
--   end
--
--   MiniPick.registry.buffers_cwd = function()
--     local cwd = vim.fs.normalize(vim.fn.getcwd()) .. '/'
--     local items = {}
--     for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
--       local buf_name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf_id))
--       if vim.startswith(buf_name, cwd) then
--         table.insert(items, { text = vim.fn.fnamemodify(buf_name, ':.'), buf_id = buf_id })
--       end
--     end
--
--     local source = { name = 'Buffers (cwd)', items = items }
--     MiniPick.start({ source = source })
--   end
--
--   require('mini.pick').setup({
--     mappings = {
--       switch = { char = '<C-k>', func = switch_picker },
--     },
--   })
-- end)

-- later(function()
--   local miniclue = require('mini.clue')
--   miniclue.setup({
--     triggers = {
--       -- Leader triggers
--       { mode = 'n', keys = '<Leader>' },
--       { mode = 'x', keys = '<Leader>' },
-- 
--       -- Built-in completion
--       { mode = 'i', keys = '<C-x>' },
-- 
--       -- `g` key
--       { mode = 'n', keys = 'g' },
--       { mode = 'x', keys = 'g' },
-- 
--       -- Marks
--       { mode = 'n', keys = "'" },
--       { mode = 'n', keys = '`' },
--       { mode = 'x', keys = "'" },
--       { mode = 'x', keys = '`' },
-- 
--       -- Registers
--       { mode = 'n', keys = '"' },
--       { mode = 'x', keys = '"' },
--       { mode = 'i', keys = '<C-r>' },
--       { mode = 'c', keys = '<C-r>' },
-- 
--       -- Window commands
--       { mode = 'n', keys = '<C-w>' },
-- 
--       -- `z` key
--       { mode = 'n', keys = 'z' },
--       { mode = 'x', keys = 'z' },
--     },
-- 
--     clues = {
--       -- Enhance this by adding descriptions for <Leader> mapping groups
--       miniclue.gen_clues.builtin_completion(),
--       miniclue.gen_clues.g(),
--       miniclue.gen_clues.marks(),
--       miniclue.gen_clues.registers(),
--       miniclue.gen_clues.windows(),
--       miniclue.gen_clues.z(),
--     },
--   })
-- end)
