return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
   'nvim-telescope/telescope.nvim', tag = '0.1.5',
      dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
  {
    'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      }
  },
  {
    'neovim/nvim-lspconfig',
      dependencies = {
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'glepnir/lspsaga.nvim',
        'williamboman/mason.nvim'
    }
  }
}
