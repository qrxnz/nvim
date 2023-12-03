local ok, catppuccin = pcall(require, "catppuccin")
if not ok then return end
vim.g.catppuccin_flavour = "mocha"
catppuccin.setup()
vim.cmd [[colorscheme catppuccin]]

require "pears".setup()

require('q.lsp')
require('q.dap')
require('q.plugins')
require('q.lualine')
require('q.telescope')
require('q.vim_options')
