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
-- vim.opt.foldlevel = 4
-- vim.opt.list = true
-- vim.opt.tabstop = 4
-- vim.opt.shiftwidth = 4
-- vim.opt.statusline =
-- "%<%f %{get(b:, 'gitsigns_status', '')} %h%m%r%=%{get(b:,'gitsigns_head','')} %{getcwd()} %-14.(%l,%c%V%) %P"

-- command
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'c', 'c++', 'javascript', 'lua', 'typescript', 'yaml', 'html', 'vim', 'json', 'nginx', 'proto', 'sh' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_user_command('Gcd', 'silent tcd %:h | silent tcd `git root` | pwd', {})
vim.api.nvim_create_user_command('JJ', ':tabfirst | edit ~/Documents/note/tmp.md |tcd %:h', {})

-- global
local function keymap_nt(lhs, rhs, opt)
  vim.keymap.set('n', lhs, rhs, opt)
  vim.keymap.set('t', lhs, '<C-\\><C-N>' .. rhs, opt)
  vim.keymap.set('i', lhs, '<Esc>' .. rhs, opt)
end
--
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

-- vim.keymap.set({ 'i', 't', 'c' }, '<M-h>', '<Left>')
-- vim.keymap.set({ 'i', 't' }, '<M-j>', '<Down>')
-- vim.keymap.set({ 'i', 't' }, '<M-k>', '<Up>')
-- vim.keymap.set({ 'i', 't', 'c' }, '<M-l>', '<Right>')

vim.keymap.set('n', '<C-s>', '<Cmd>silent! update<CR>')
vim.keymap.set('i', '<C-s>', '<Esc><Cmd>silent! update<CR>')
vim.keymap.set('t', '<C-s>', '<C-\\><C-N>')
vim.keymap.set('v', '<space>y', '"+y')
vim.keymap.set('n', '<space>y', '"+Y')
vim.keymap.set('v', '<D-c>', '"+y')
vim.keymap.set('n', '<D-c>', '"+Y')

-- vim.keymap.set('n', '<C-j>', '<C-w>w', { desc = 'Focus on below window' })
-- vim.keymap.set('n', '<C-k>', '<C-w>W', { desc = 'Focus on above window' })

vim.keymap.set('n', '<space>n', '<C-w>gf:Gcd<cr>')
vim.keymap.set('n', '<space>ss', ':wa | mksession! ~/.config/work.vim<cr>')
vim.keymap.set('n', '<space>so', ':so ~/.config/work.vim<cr>')
vim.keymap.set('n', '<space><space>', ':JJ<cr>', { silent = true })
vim.keymap.set('n', '<space>d', ':tcd %:h<cr>')
vim.keymap.set('n', '<space>=', ':lua vim.lsp.buf.format({async=true})<cr>')

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


-- Define a function to generate the tabline
vim.cmd([[
        highlight TabLineSel guifg=#ffffff guibg=#005f87 guibg=bold
        highlight TabLine guifg=#ffffff guibg=#002b36
        highlight TabLineFill guifg=#ffffff guibg=#002b36
      ]])


local function trim_prefix(str, prefix)
  if string.sub(str, 1, string.len(prefix)) == prefix then
    return string.sub(str, string.len(prefix) + 1)
  end
  return vim.fn.pathshorten(vim.fn.fnamemodify(str, ":~:."))
end

function _G.CustomTabline()
  local tabline = ''
  local tabs = vim.api.nvim_list_tabpages()
  local cur_tab = vim.api.nvim_get_current_tabpage()

  local check_modify = function(wins)
    for _, win in pairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      local option = vim.api.nvim_get_option_value("modified", { buf = buf })
      if option then
        return '+'
      end
    end
    return ''
  end

  for index, tab in ipairs(tabs) do
    local hl    = '%#TabLine#'
    local wins  = vim.api.nvim_tabpage_list_wins(tab)
    local mark  = check_modify(wins)
    local count = #wins > 1 and tostring(#wins) or ''
    local win   = wins[1]

    if cur_tab == tab then
      hl = '%#TabLineSel#'
      win = vim.api.nvim_get_current_win()
    end

    local tcd   = vim.fn.getcwd(-1, tab)
    local label = tcd:match("([^/]+)$")
    local buf   = vim.api.nvim_win_get_buf(win)
    local name  = trim_prefix(vim.api.nvim_buf_get_name(buf), tcd .. '/')
    tabline     = tabline .. hl .. ' ' .. index .. ':' .. count .. mark .. ' ' .. label .. '|' .. name .. ' '
  end

  -- Return the tabline with custom formatting
  return tabline .. '%#TabLineFill#'
end

vim.o.tabline = '%!v:lua.CustomTabline()'

-- vim.cmd.colorscheme('github_dark_default')
-- vim.cmd.colorscheme('tokyonight-night')

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   callback = function()
--     vim.lsp.buf.format({ async = true })
--   end
-- })

-- ./lua/plugins/lsp.lua
-- ./lua/plugins/plugins.lua
--
-- init.lua
