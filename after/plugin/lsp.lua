-- Native Neovim 0.11 LSP setup (replaces lsp-zero)

-- Global defaults merged into every server config
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Mason: used ONLY for non-Go servers. All Go tooling (gopls, templ,
-- golangci-lint-langserver, goimports, dlv, ...) is managed by my own Go
-- toolchain in ~/go/bin so there's a single source of truth.
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = { 'ts_ls', 'pylsp' },
  -- Don't let Mason auto-enable Go servers it might still have installed;
  -- we enable those explicitly below from PATH (~/go/bin).
  automatic_enable = { exclude = { 'gopls', 'templ', 'golangci_lint_ls' } },
})

-- Go servers, resolved from PATH (~/go/bin) via nvim-lspconfig's base configs.
-- vim.lsp.enable uses the `lsp/<name>.lua` runtime config shipped by
-- nvim-lspconfig (cmd/filetypes/root_dir) plus my after/lsp/gopls.lua overrides.
vim.lsp.enable({ 'gopls', 'templ', 'golangci_lint_ls' })

-- Per-server customization (merges with nvim-lspconfig's lsp/pylsp.lua)
vim.lsp.config('pylsp', {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { ignore = { 'W391' }, maxLineLength = 100 },
      },
    },
  },
})

-- Buffer-local keymaps + inlay hints, server-agnostic
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspAttach', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    -- Complement the 0.11 defaults (grn/gra/grr/gri/grt/K/gO/<C-s>)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
    vim.keymap.set({ 'n', 'x' }, '<F3>', function()
      vim.lsp.buf.format({ async = true })
    end, opts)

    -- Inlay hints (Nvim 0.11 + gopls 0.23 support them)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
  end,
})

-- Completion
-- Load friendly-snippets (VSCode-format) into LuaSnip
require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args) require('luasnip').lsp_expand(args.body) end,
  },
})
