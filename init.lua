vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Define main config table to be able to use it in scripts
_G.Config = {}

require('vim._extui').enable({})

require('my.option')
require('my.function')
require('my.plugin')
require('my.keymap')
