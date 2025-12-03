return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      diagnostics = {
        -- disable = {"luadoc-miss-see-name"},
        globals = {'MiniPick', 'MiniExtra'},
      },
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        }
      }
    }
  }
}
