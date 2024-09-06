local function trim_prefix(str, prefix)
  if string.sub(str, 1, string.len(prefix)) == prefix then
    return string.sub(str, string.len(prefix) + 1)
  end
  return vim.fn.pathshorten(vim.fn.fnamemodify(str, ":~:."))
end

function _G.MyTabline()
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
    vim.api.nvim_tabpage_get_number(tab)
    local hl    = '%#TabLine#'
    local wins  = vim.api.nvim_tabpage_list_wins(tab)
    local mark  = check_modify(wins)
    local count = #wins > 1 and tostring(#wins) or ''
    local win   = wins[1]

    if cur_tab == tab then
      hl = '%#TabLineSel#'
      win = vim.api.nvim_get_current_win()
    end
    local tcd   = vim.fn.getcwd(-1, index)
    local label = tcd:match("([^/]+)$")
    local buf   = vim.api.nvim_win_get_buf(win)
    local name  = trim_prefix(vim.api.nvim_buf_get_name(buf), tcd .. '/')
    tabline     = tabline .. hl .. ' ' .. index .. ':' .. count .. mark .. ' ' .. label .. '|' .. name .. ' '
  end

  return tabline .. '%#TabLineFill#'
end

local function icon_with(icon, str)
  return (str == nil or str == '') and '' or icon .. str
end

---@return string
local function lsp_status()
  local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
  if #attached_clients == 0 then return "" end
  local it = vim.iter(attached_clients)
  it:map(function(client)
    local name = client.name:gsub("language.server", "ls")
    return name
  end)
  local names = it:totable()
  return "[" .. table.concat(names, ", ") .. "]"
end

local function diagnostics()
  local count = vim.diagnostic.count(0)
  local signs = { 'E', 'W', 'I', 'H' }
  local s = ''
  for level, n in pairs(count) do
    s = s .. ' ' .. signs[level] .. n
  end
  return icon_with('', s)
end

function _G.MyStatusline()
  return table.concat({
    "%f",
    "%h%w%m%r",
    icon_with(' ', vim.b.minigit_summary_string),
    icon_with(' ', vim.b.minidiff_summary_string),
    diagnostics(),
    "%=",
    lsp_status(),
    " %-14(%l,%c%V%)",
    "%P",
  }, " ")
end

vim.o.statusline = "%{%v:lua.MyStatusline()%}"
vim.o.tabline = '%!v:lua.MyTabline()'
