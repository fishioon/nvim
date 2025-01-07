vim.o.mouse          = 'a'
-- vim.o.showmode       = false
-- vim.o.switchbuf      = 'usetab'
-- vim.o.background     = 'dark'
vim.o.cursorline     = true
vim.o.number         = true
vim.o.relativenumber = true
vim.o.signcolumn     = 'number'
vim.o.ignorecase     = true
vim.o.smartcase      = true
vim.o.laststatus     = 3
vim.o.splitbelow     = true
vim.o.splitright     = true

vim.o.foldmethod     = 'expr'
vim.o.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldenable     = true
vim.o.foldlevel      = 99 -- start editing with all folds opened

vim.o.tabstop        = 4
vim.o.termguicolors  = true
-- vim.o.cmdheight      = 0
-- vim.o.completeopt    = 'menu,menuone,noinsert,fuzzy,popup'
-- vim.o.completeopt    = 'menu,preview'
-- vim.o.listchars      = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',')
-- vim.o.cursorlineopt  = 'screenline,number' -- Show cursor line only screen line when wrapped

vim.o.completeopt    = "menu,menuone,popup,fuzzy" -- modern completion menu
vim.o.list           = false
