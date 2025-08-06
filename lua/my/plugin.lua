local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Use 'HEAD' because I personally update it and don't want to follow `main`
-- This means that 'start/mini.nvim' will usually be present twice in
-- 'runtimepath' as there is a '.../pack/*/start/*' entry there.
add({ name = 'mini.nvim', checkout = 'HEAD' })

now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })
  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

now(function()
  local predicate = function(notif)
    if not (notif.data.source == 'lsp_progress' and notif.data.client_name == 'lua_ls') then return true end
    -- Filter out some LSP progress notifications from 'lua_ls'
    return notif.msg:find('Diagnosing') == nil and notif.msg:find('semantic tokens') == nil
  end
  local custom_sort = function(notif_arr) return MiniNotify.default_sort(vim.tbl_filter(predicate, notif_arr)) end

  require('mini.notify').setup({ content = { sort = custom_sort } })
  vim.notify = MiniNotify.make_notify()
end)

now(function() require('mini.sessions').setup() end)

now(function() require('mini.starter').setup() end)

now(function() require('mini.statusline').setup() end)

-- Future part of 'mini.detect'
-- TODO: Needs some condition to stop the comb.
_G.detect_bigline = function(threshold)
  threshold = threshold or 1000
  local step = math.floor(0.5 * threshold)
  local cur_line, cur_byte = 1, step
  local byte2line = vim.fn.byte2line
  while cur_line > 0 do
    local test_line = byte2line(cur_byte)
    if test_line == cur_line and #vim.fn.getline(test_line) >= threshold then return cur_line end
    cur_line, cur_byte = test_line, cur_byte + step
  end
  return -1
end

-- Unfortunately, `_lines` is ~3x faster
_G.get_all_indent_lines = function()
  local res, lines = {}, vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i = 1, #lines do
    local indent = lines[i]:match('^%s+')
    if indent ~= nil then table.insert(res, indent) end
  end
  return res
end

_G.get_all_indent_text = function()
  local res, n = {}, vim.api.nvim_buf_line_count(0)
  local get_text = vim.api.nvim_buf_get_text
  for i = 1, n do
    local first_byte = get_text(0, i - 1, 0, i - 1, 1, {})[1]
    if first_byte == '\t' or first_byte == ' ' then table.insert(res, vim.fn.getline(i):match('^%s+')) end
  end
  return res
end

-- Unfortunately, `_lines` is 10x faster
_G.get_maxwidth_lines = function()
  local res, lines = 0, vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i = 1, #lines do
    res = res < lines[i]:len() and lines[i]:len() or res
  end
  return res
end

_G.get_maxwidth_bytes = function()
  local res, n = 0, vim.api.nvim_buf_line_count(0)
  local cur_byte, line2byte = 1, vim.fn.line2byte
  for i = 2, n + 1 do
    local new_byte = line2byte(i)
    res = math.max(res, new_byte - cur_byte)
    cur_byte = new_byte
  end
  return res - 1
end

-- Step two ===================================================================
later(function() require('mini.extra').setup() end)

later(function()
  local ai = require('mini.ai')
  ai.setup({
    custom_textobjects = {
      B = MiniExtra.gen_ai_spec.buffer(),
      F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    },
  })
end)

-- later(function() require('mini.align').setup() end)
-- later(function() require('mini.animate').setup({ scroll = { enable = false } }) end)

later(function() require('mini.bracketed').setup() end)

later(function() require('mini.bufremove').setup() end)

later(function()
  local miniclue = require('mini.clue')
  --stylua: ignore
  miniclue.setup({
    clues = {
      Config.leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' }, -- Leader triggers
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = [[\]] },      -- mini.basics
      { mode = 'n', keys = '[' },        -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' }, -- Built-in completion
      { mode = 'n', keys = 'g' },     -- `g` key
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },     -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' }, -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' }, -- Window commands
      { mode = 'n', keys = 'z' },     -- `z` key
      { mode = 'x', keys = 'z' },
    },
  })
end)

later(function() require('mini.cursorword').setup() end)

later(function() require('mini.diff').setup() end)

later(function()
  require('mini.files').setup({ windows = { preview = true } })
end)

later(function() require('mini.git').setup() end)

later(function()
  local hipatterns = require('mini.hipatterns')
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(function()
  local map_multistep = require('mini.keymap').map_multistep
  -- map_multistep('i', '<Tab>', { 'pmenu_next' })
  -- map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
  map_multistep('i', '<BS>', { 'minipairs_bs' })

  local notify_many_keys = function(key)
    local lhs = string.rep(key, 5)
    local action = function() vim.notify('Too many ' .. key) end
    require('mini.keymap').map_combo({ 'n', 'x' }, lhs, action)
  end
  notify_many_keys('h')
  notify_many_keys('j')
  notify_many_keys('k')
  notify_many_keys('l')
end)

later(function()
  local map = require('mini.map')
  local gen_integr = map.gen_integration
  map.setup({
    symbols = { encode = map.gen_encode_symbols.dot('4x2') },
    integrations = { gen_integr.builtin_search(), gen_integr.diff(), gen_integr.diagnostic() },
  })
  vim.keymap.set('n', [[\h]], ':let v:hlsearch = 1 - v:hlsearch<CR>', { desc = 'Toggle hlsearch', silent = true })
  for _, key in ipairs({ 'n', 'N', '*' }) do
    vim.keymap.set('n', key, key .. 'zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>')
  end
end)

later(function()
  require('mini.misc').setup({ make_global = { 'put', 'put_text', 'stat_summary', 'bench_time' } })
  MiniMisc.setup_auto_root()
  MiniMisc.setup_termbg_sync()
end)

later(function() require('mini.move').setup({ options = { reindent_linewise = false } }) end)

-- later(function() require('mini.operators').setup() end)

later(function() require('mini.pairs').setup({ modes = { insert = true, command = true, terminal = true } }) end)

later(function()
  require('mini.pick').setup()
  vim.ui.select = MiniPick.ui_select
  vim.keymap.set('n', ',', '<Cmd>Pick buf_lines scope="current" preserve_order=true<CR>', { nowait = true })

  MiniPick.registry.projects = function()
    local cwd = vim.fn.expand('~/git')
    local choose = function(item)
      vim.schedule(function() MiniPick.builtin.files(nil, { source = { cwd = item.path } }) end)
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end
end)

later(function()
  local snippets, config_path = require('mini.snippets'), vim.fn.stdpath('config')

  local lang_patterns = {
    tex = { 'latex.json' },
    plaintex = { 'latex.json' },
    markdown_inline = { 'markdown.json' },
  }
  local load_if_minitest_buf = function(context)
    local buf_name = vim.api.nvim_buf_get_name(context.buf_id)
    local is_test_buf = vim.fn.fnamemodify(buf_name, ':t'):find('^test_.+%.lua$') ~= nil
    if not is_test_buf then return {} end
    return MiniSnippets.read_file(config_path .. '/snippets/mini-test.json')
  end

  snippets.setup({
    snippets = {
      snippets.gen_loader.from_file(config_path .. '/snippets/global.json'),
      snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
      load_if_minitest_buf,
    },
  })
end)

later(function() require('mini.splitjoin').setup() end)

later(function()
  require('mini.surround').setup()
  -- Disable `s` shortcut (use `cl` instead) for safer usage of 'mini.surround'
  vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
end)

later(function() require('mini.test').setup() end)

later(function() require('mini.trailspace').setup() end)

later(function() require('mini.visits').setup() end)

later(function() add('rafamadriz/friendly-snippets') end)

later(function()
  vim.lsp.config('*', {
    capabilities = {
      textDocument = {
        semanticTokens = {
          multilineTokenSupport = true,
        }
      }
    },
    root_markers = { '.git' },
  })

  vim.lsp.config('jsonls', {
    cmd = { 'vscode-json-languageserver', '--stdio' },
    filetypes = { 'json' },
  })

  vim.lsp.config('tsls', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'typescript' },
  })

  vim.lsp.config('yamls', {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml' },
  })

  vim.lsp.enable({ 'luals', 'gopls', 'tsls' })

  vim.api.nvim_set_hl(0, 'SnacksPickerDir', {
    link = 'Comment',
  })
end)

later(function()
  add("zbirenbaum/copilot.lua")
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
end)

later(function()
  add({ source = 'fishioon/cmd.nvim', depends = { 'fishioon/term.nvim' } })
  require('cmd').setup({})
end)

later(function()
  add({
    source = 'saghen/blink.cmp',
    depends = { "rafamadriz/friendly-snippets" },
    checkout = 'v1.6.0',
  })
  require('blink.cmp').setup({
    keymap = { preset = 'default' },
    completion = { documentation = { auto_show = false } },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'cmdline' },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  })
end)

later(function()
  add({ source = 'nvim-treesitter/nvim-treesitter', branch = 'main' })
  require'nvim-treesitter.configs'.setup {
    ensure_installed = { 'lua', 'vim', 'vimdoc', 'markdown', 'markdown_inline', 'json', 'yaml', 'html', 'css' },
    highlight = {
      enable = true,
      -- additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
      -- disable = { 'yaml' }, -- YAML indent is not good
    },
  }
end)
