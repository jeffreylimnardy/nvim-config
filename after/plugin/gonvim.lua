require('go').setup({
  lsp_cfg = false,                      -- native vim.lsp.config owns gopls
  lsp_inlay_hints = { enable = false }, -- handled natively in LspAttach
  luasnip = true,
})

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  group = format_sync_grp,
  callback = function()
    require('go.format').goimports()
  end,
})

-- Go command keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    local opts = { buffer = true }
    vim.keymap.set('n', '<leader>gt', '<cmd>GoTest<cr>', opts)
    vim.keymap.set('n', '<leader>gtf', '<cmd>GoTestFunc<cr>', opts)
    vim.keymap.set('n', '<leader>gc', '<cmd>GoCoverage<cr>', opts)
    vim.keymap.set('n', '<leader>ge', '<cmd>GoIfErr<cr>', opts)
    vim.keymap.set('n', '<leader>gfs', '<cmd>GoFillStruct<cr>', opts)
    vim.keymap.set('n', '<leader>gat', '<cmd>GoAddTag<cr>', opts)
    vim.keymap.set('n', '<leader>grt', '<cmd>GoRmTag<cr>', opts)
    vim.keymap.set('n', '<leader>gi', '<cmd>GoImpl<cr>', opts)
    vim.keymap.set('n', '<leader>ga', '<cmd>GoAlternate<cr>', opts)
  end,
})
