--}} This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '

local plugins = {
  'nvim-treesitter/playground',
  'ray-x/go.nvim',
  'ray-x/guihua.lua', -- recommended if need floating window support
  "nvim-lua/plenary.nvim", -- don't forget to add this one if you don't have it yet!
  { "catppuccin/nvim", name = "catppuccin" },
  { 'fcancelinha/nordern.nvim', name = "nordern" },
  {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
  {'nvim-telescope/telescope.nvim',
    version = '0.1.8',
	dependencies = { {'nvim-lua/plenary.nvim'} }
  },
  {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v1.x',
      dependencies = {
          -- LSP Support
          {'neovim/nvim-lspconfig'},
          {'williamboman/mason.nvim'},
          {'williamboman/mason-lspconfig.nvim'},

          -- Autocompletion
          {'hrsh7th/nvim-cmp'},
          {'hrsh7th/cmp-buffer'},
          {'hrsh7th/cmp-path'},
          {'saadparwaiz1/cmp_luasnip'},
          {'hrsh7th/cmp-nvim-lsp'},
          {'hrsh7th/cmp-nvim-lua'},

          -- Snippets
          {'L3MON4D3/LuaSnip'},
          {'rafamadriz/friendly-snippets'},
      }
  },
  {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" }
  },
}

local opts = {}

require("lazy").setup(plugins, opts)
