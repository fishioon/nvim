-- Define main config table to be able to use it in scripts
vim.g.mapleader      = ' '
vim.o.mouse          = 'a'
vim.o.cursorline     = true
vim.o.number         = true
vim.o.relativenumber = true
vim.o.signcolumn     = 'number'
vim.o.ignorecase     = true
vim.o.smartcase      = true
vim.o.laststatus     = 3
vim.o.splitbelow     = true
vim.o.splitright     = true
vim.o.tabstop        = 4
vim.o.cmdheight      = 0
vim.o.autocomplete   = true
vim.o.completeopt    = 'menu,menuone,noinsert,fuzzy,popup'
vim.o.acl = 300

require('vim._extui').enable({
  enable = true,
  timeout = 5000,
})

require('my.function')
require('my.plugin')
require('my.keymap')
