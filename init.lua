-- _____   __          ___    ______            
-- ___  | / /____________ |  / /__(_)______ ___ 
-- __   |/ /_  _ \  __ \_ | / /__  /__  __ `__ \
-- _  /|  / /  __/ /_/ /_ |/ / _  / _  / / / / /
-- /_/ |_/  \___/\____/_____/  /_/  /_/ /_/ /_/

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
