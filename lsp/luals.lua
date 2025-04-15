return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
          vim.fn.stdpath('data') .. '/lazy/snacks.nvim',
          vim.fn.stdpath('data') .. '/lazy/mini.nvim',
        }
      }
    }
  }
}
