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
  'ray-x/go.nvim',
  'ray-x/guihua.lua', -- recommended if need floating window support
  "nvim-lua/plenary.nvim", -- don't forget to add this one if you don't have it yet!
  { 'fcancelinha/nordern.nvim', name = "nordern" },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
  },
  {'nvim-telescope/telescope.nvim',
    -- Unpinned (track master): the 0.1.8 tag predates Neovim 0.12 and calls
    -- the removed vim.treesitter.language.ft_to_lang + old nvim-treesitter API.
    dependencies = { {'nvim-lua/plenary.nvim'} }
  },
  -- LSP + Mason (native vim.lsp.config, Neovim 0.11+)
  { 'neovim/nvim-lspconfig' },
  { 'mason-org/mason.nvim', opts = {} },
  { 'mason-org/mason-lspconfig.nvim', opts = {} },

  -- Completion
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'saadparwaiz1/cmp_luasnip' },

  -- Snippets
  { 'L3MON4D3/LuaSnip' },
  { 'rafamadriz/friendly-snippets' },
  {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" }
  },
}

local opts = {}

require("lazy").setup(plugins, opts)
