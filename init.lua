-- plugins
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'nvim-treesitter.configs'.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "json", "go" },
        highlight = { enable = true }
      })
    end
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require('nvim-surround').setup({})
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          layout_config = {
            vertical = { width = 0.5 }
          },
          mappings = {
            n = {
              ['dd'] = require('telescope.actions').delete_buffer
            },
          },
        },
      })
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({})
    end
  },
  {
    'neovim/nvim-lspconfig',
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  },
  {
    'nvimdev/epo.nvim',
    dev = true,
    enable = false,
    config = function()
      require('epo').setup({
        fuzzy = false,
        debounce = 50,
        signature = false,
        snippet_path = vim.fn.stdpath('config') .. '/snippets/',
        signature_border = 'rounded',
        kind_format = function(k)
          return k:lower():sub(1, 1)
        end
      })
      vim.keymap.set('i', '<TAB>', function()
        if vim.fn.pumvisible() == 1 then
          return '<C-n>'
        elseif vim.snippet.jumpable(1) then
          return '<cmd>lua vim.snippet.jump(1)<cr>'
        else
          return '<TAB>'
        end
      end, { expr = true })

      vim.keymap.set('i', '<S-TAB>', function()
        if vim.fn.pumvisible() == 1 then
          return '<C-p>'
        elseif vim.snippet.jumpable(-1) then
          return '<cmd>lua vim.snippet.jump(-1)<CR>'
        else
          return '<S-TAB>'
        end
      end, { expr = true })

      vim.keymap.set('i', '<C-e>', function()
        if vim.fn.pumvisible() == 1 then
          require('epo').disable_trigger()
        end
        return '<C-e>'
      end, { expr = true })

      vim.keymap.set("i", "<cr>", function()
        if vim.fn.pumvisible() == 1 then
          return "<C-y>"
        end
        return "<cr>"
      end, { expr = true, noremap = true })
    end
  },
  {
    'fishioon/cmd.nvim',
    dev = false,
    config = function()
      require('cmd').setup({})
    end
  },
  {
    'fishioon/term.nvim',
    dev = false,
    config = function()
      require('term').setup({})
    end
  },
  {
    'kevinhwang91/nvim-bqf',
  },
  {
    "robitx/gp.nvim",
    config = function()
      require("gp").setup({})
      vim.keymap.set('n', "<space>wp", "<cmd>GpChatToggle<cr>")
    end,
  },
}

require('lazy').setup(plugins, {
  dev = {
    path = '~/git',
  },
})
-----------------------
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.opt.background = 'dark'
vim.opt.number = true
vim.opt.signcolumn = 'number'
vim.opt.colorcolumn = '120'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 3
vim.opt.splitbelow = true
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false
vim.opt.termguicolors = true
vim.opt.statusline =
"%<%f %{get(b:, 'gitsigns_status')} %h%m%r%=%{get(b:,'gitsigns_head','')}  %{getcwd()} %-14.(%l,%c%V%) %P"

-- command
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'c', 'c++', 'javascript', 'lua', 'typescript', 'yaml', 'html', 'vim', 'json', 'nginx', 'proto', 'sh' },
  command = 'setlocal ts=2 sw=2 sts=2 expandtab',
})

vim.api.nvim_create_user_command('Gcd', 'lcd %:h | lcd `git root` | pwd', {})
vim.api.nvim_create_user_command('JSON', ':set ft=json', {})
vim.api.nvim_create_user_command('JS', ':set ft=javascript', {})
vim.api.nvim_create_user_command('COPY', ':let @+ = expand("%:p")', {})
vim.api.nvim_create_user_command('JJ', ':tabfirst | edit ~/Documents/note/tmp.md |lcd %:h', {})

-- global
vim.keymap.set('t', '<C-j>', '<C-\\><C-N><C-w>w')
vim.keymap.set('t', '<C-k>', '<C-\\><C-N><C-w>W')
vim.keymap.set('n', '<C-j>', '<C-w>w')
vim.keymap.set('n', '<C-k>', '<C-w>W')
vim.keymap.set('n', '<space><space>', ':JJ<cr>', { silent = true })
vim.keymap.set('n', '<space>0', ':tablast<cr>')
vim.keymap.set('n', '<space>1', '1gt')
vim.keymap.set('n', '<space>2', '2gt')
vim.keymap.set('n', '<space>3', '3gt')
vim.keymap.set('n', '<space>d', ':Gcd<cr>')
vim.keymap.set('n', '[b', ':bprev<cr>')
vim.keymap.set('n', ']b', ':bnext<cr>')
vim.keymap.set('n', '<space>n', '<C-w>gf:Gcd<cr>')
vim.keymap.set('n', '<space>wg', ':tabnew<CR>:terminal lazygit<CR>i')
vim.keymap.set("v", "<space>y", '"+y')

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<space>p', builtin.resume, {})
vim.keymap.set('n', '<space>f', builtin.find_files, {})
vim.keymap.set('n', '<space>/', builtin.live_grep, {})
vim.keymap.set('n', '<space>g', builtin.grep_string, {})
vim.keymap.set('n', '<space>b', function() builtin.buffers({ sort_mru = true }) end, {})

-- gitsigns
vim.keymap.set('n', '<space>wd', ':Gitsigns diffthis<cr>', {})

-- lsp & cmp
local capabilities = vim.tbl_deep_extend(
  'force',
  vim.lsp.protocol.make_client_capabilities(),
  require('epo').register_cap()
)
local conf = { capabilities = capabilities }
local lspconfig = require('lspconfig')
lspconfig['lua_ls'].setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'require', 'ngx' }
      },
      runtime = {
        version = 'Lua 5.1'
      },
    }
  },
})

lspconfig.gopls.setup(conf)
lspconfig.tsserver.setup(conf)
lspconfig.bashls.setup(conf)

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    -- vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>=', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local function run_cmd(cmd)
  cmd = cmd or require('cmd').cmd()
  require('term').send(cmd .. '\n', false)
end

local function copy_cmd()
  local cmd = require('cmd').cmd()
  vim.fn.setreg('+', cmd)
  vim.print(cmd)
end

local function run_cmd_with_ls()
  return run_cmd('ls')
end

vim.keymap.set("n", "<space>e", run_cmd, { silent = true })
vim.keymap.set("n", "<space>y", copy_cmd, { silent = false })
vim.keymap.set("n", "<space>t", run_cmd_with_ls, { silent = true })
vim.keymap.set("n", "<space>h", "<cmd>GpChatToggle<cr>")

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  pattern = '*',
  command = 'silent! normal! g`"zv'
})
