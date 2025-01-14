local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now
later(function()
  add('folke/snacks.nvim')
  require('snacks').setup({
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
  })
end)

later(function()
  add('nvim-treesitter/nvim-treesitter')
  add('nvim-treesitter/nvim-treesitter-textobjects')
  require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "json", "go" },
    highlight = { enable = true },
    ignore_install = {},
    sync_install = false,
    auto_install = false,
    modules = {},
  })
end)

later(function()
  add('fishioon/cmd.nvim')
  add('fishioon/term.nvim')
end)

later(function()
  -- add('williamboman/mason.nvim')
  -- require('mason').setup()

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

  vim.lsp.config('sqlls', {
    cmd = { 'sqlls-language-server', '--stdio' },
    filetypes = { 'sql' },
  })

  vim.lsp.config('helmls', {
    cmd = { 'helm_ls', 'serve' },
    filetypes = { 'helm' },
  })

  vim.lsp.enable({ 'luals', 'gopls', 'jsonls', 'tsls', 'yamls', 'helmls' })
end)

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

later(function()
  local function build_blink(params)
    vim.notify('Building blink.cmp', vim.log.levels.INFO)
    local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
    if obj.code == 0 then
      vim.notify('Building blink.cmp done', vim.log.levels.INFO)
    else
      vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
    end
  end

  add({
    source = "saghen/blink.cmp",
    depends = {
      "rafamadriz/friendly-snippets",
    },
    hooks = {
      post_install = build_blink,
      post_checkout = build_blink,
    },
  })

  require('blink.cmp').setup({
    keymap = {
      preset = 'default',
      cmdline = {
        preset = 'default',
      },
    }
  })
end)

later(function()
  add('zbirenbaum/copilot.lua')
  add({
    source = 'yetone/avante.nvim',
    monitor = 'main',
    depends = {
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
  })
  require('copilot').setup({
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>"
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = false,
      debounce = 50,
      keymap = {
        accept = "<C-l>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      yaml = true,
      markdown = true,
      help = false,
      gitcommit = true,
      gitrebase = true,
      ["."] = false,
    },
    copilot_node_command = 'node', -- Node.js version must be > 18.x
    server_opts_overrides = {},
  })
end)

add({
  source = 'yetone/avante.nvim',
  monitor = 'main',
  depends = {
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'MeanderingProgrammer/render-markdown.nvim',
  },
  hooks = { post_checkout = function() vim.cmd('make') end }
})
--- optional
add({ source = 'MeanderingProgrammer/render-markdown.nvim' })

now(function() require('avante_lib').load() end)
later(function() require('render-markdown').setup() end)
later(function()
  require("avante").setup({
    provider = "copilot",
    auto_suggestions_provider = "openai",
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true,
    },
  })
end)
