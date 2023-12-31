-- _____   __          ___    ______            
-- ___  | / /____________ |  / /__(_)______ ___ 
-- __   |/ /_  _ \  __ \_ | / /__  /__  __ `__ \
-- _  /|  / /  __/ /_/ /_ |/ / _  / _  / / / / /
-- /_/ |_/  \___/\____/_____/  /_/  /_/ /_/ /_/

-- Vim Opts
local options = {
  ma = true,
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  autoindent = true,
  expandtab = true,
  autoread = true,
  nu = true,
  backup = false,
  writebackup = false,
  swapfile = false,
  clipboard = "unnamedplus",
  showmode = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Lazy/Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- Colorscheme
require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
      dark = "mocha",
  },
  transparent_background = false, -- disables setting the background color.
  show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false, -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  no_underline = false, -- Force no underline
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" }, -- Change the style of comments
    conditionals = { "italic" },
  },
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
      mini = {
        enabled = true,
        indentscope_color = "",
    },
  },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"

-- Treesitter
local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
  sync_install = false, 
  highlight = { enable = true },
  indent = { enable = true },  
})

-- Lualine
require('lualine').setup{
  options = {
    theme = 'auto',
    icons_enabled = false,
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'buffers'},
    lualine_x = {'tabs'},
    lualine_y = {'progress'},
    lualine_z = {
      { 'diagnostics',
        sources = {'nvim_diagnostic', 'nvim_lsp'},
        sections = {'error', 'warn', 'info', 'hint'},
        diagnostics_color = {
          -- Same values as the general color option can be used here.
          error = 'DiagnosticError', -- Changes diagnostics' error color.
          warn  = 'DiagnosticWarn',  -- Changes diagnostics' warn color.
          info  = 'DiagnosticInfo',  -- Changes diagnostics' info color.
          hint  = 'DiagnosticHint',  -- Changes diagnostics' hint color.
        },
        symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},
        colored = true,           -- Displays diagnostics status in color if set to true.
        update_in_insert = false, -- Update diagnostics in insert mode.
        always_visible = false,   -- Show diagnostics even if there are none.
      }
    }
  }
}

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-a>', builtin.find_files, {})

-- Neo-tree
vim.keymap.set('n', '<C-l>', ':Neotree filesystem reveal right<CR>', {})

-- Cmp/Lspconfig
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<CR>'] = function(fallback)
      if cmp.visible() then
        cmp.confirm()
      else
        fallback()
      end
    end
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, bufnr)

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- leaving only what I actually use...
  nmap { "K", "<cmd>Lspsaga hover_doc<CR>", opts }
  -- nmap { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts }
  nmap { "gd", "<cmd>Telescope lsp_definitions<CR>", opts }
  nmap { "gr", "<cmd>Telescope lsp_references<CR>", opts }
  nmap { "<C-j>", "<cmd>Telescope lsp_document_symbols<CR>", opts }
  nmap { "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts }

  nmap { "gi", "<cmd>Telescope lsp_implementations<CR>", opts }
  nmap { "<leader>D", "<cmd>Telescope lsp_type_definitions<CR>", opts }
  nmap { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts }
  nmap { '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts }
  nmap { "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts }
  nmap { "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts }
  nmap { "<leader>dj", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts }
  nmap { "<leader>dk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts }
  nmap { "<leader>r", "<cmd>Lspsada rename<CR>", opts }

  vim.cmd([[
            augroup formatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
                autocmd BufWritePre <buffer> lua OrganizeImports(1000)
            augroup END
        ]])

  -- Set autocommands conditional on server_capabilities
  vim.cmd([[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]])
end

-- organize imports
-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-902680058
function OrganizeImports(timeoutms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeoutms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

local lspconfig = require('lspconfig')
lspconfig.gopls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      gofumpt = true,
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
}

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.pylsp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.clangd.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.hls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.golangci_lint_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      gofumpt = true,
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
}

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {
    "rustup", "run", "stable", "rust-analyzer",
  }
}

-- Autoclose
require("autoclose").setup({
   options = {
      disabled_filetypes = { "text" },
      disable_when_touch = false,
      touch_regex = "[%w(%[{]",
      pair_spaces = false,
      auto_indent = true,
      disable_command_mode = false,
   },
})
