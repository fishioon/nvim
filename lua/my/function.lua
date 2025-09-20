if not _G.Config then _G.Config = {} end

-- Create listed scratch buffer and focus on it
Config.new_scratch_buffer = function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end

-- Execute current line with `lua`
Config.execute_lua_line = function()
  local line = 'lua ' .. vim.api.nvim_get_current_line()
  vim.api.nvim_command(line)
  print(line)
  vim.api.nvim_input('<Down>')
end

-- Tabpage with lazygit
Config.open_lazygit = function()
  vim.cmd('tabedit')
  vim.cmd('setlocal nonumber signcolumn=no')

  -- Unset vim environment variables to be able to call `vim` without errors
  -- Use custom `--git-dir` and `--work-tree` to be able to open inside
  -- symlinked submodules
  vim.fn.jobstart('VIMRUNTIME= VIM= lazygit --git-dir=$(git rev-parse --git-dir) --work-tree=$(realpath .)', {
    term = true,
    on_exit = function()
      vim.cmd('silent! :checktime')
      vim.cmd('silent! :bw')
    end,
  })
  vim.cmd('startinsert')
end

-- Toggle quickfix window
Config.toggle_quickfix = function()
  local cur_tabnr = vim.fn.tabpagenr()
  for _, wininfo in ipairs(vim.fn.getwininfo()) do
    if wininfo.quickfix == 1 and wininfo.tabnr == cur_tabnr then return vim.cmd('cclose') end
  end
  vim.cmd('copen')
end

Config.term_open = function(toggle, cmd, split)
  split = split or 'vsplit'
  cmd = cmd or os.getenv('SHELL')
  local prefix = 'term://' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
  local suffix = ':' .. cmd

  -- Check if 'claude' is already open
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.startswith(name, 'term://') and vim.endswith(name, suffix) then
      if toggle then
        vim.api.nvim_win_close(win, true)
      else
        vim.api.nvim_set_current_win(win)
        vim.cmd('startinsert')
      end
      return
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.startswith(name, prefix) and vim.endswith(name, ':' .. cmd) then
      vim.cmd(split .. ' #' .. buf)
      vim.cmd('startinsert')
      return
    end
  end

  -- If not, open it in a vertical split
  vim.cmd(split .. '| terminal ' .. cmd)
  vim.cmd('startinsert')
end

Config.term_exec = function()
  local text = require('my.cmd').cmd()
  Config.term_open(false)
  vim.api.nvim_paste(text, true, -1)
  vim.api.nvim_input('<CR>')
end
