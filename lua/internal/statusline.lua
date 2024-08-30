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

  -- Return the tabline with custom formatting
  return tabline .. '%#TabLineFill#'
end

vim.o.tabline = '%!v:lua.CustomTabline()'
