-- nvim-treesitter `main` branch API (required for Neovim 0.12+).
-- The old `require'nvim-treesitter.configs'.setup{ ... }` no longer exists.

-- Parsers to install. On the main branch this is explicit; there is no
-- `ensure_installed`/`auto_install` option in a setup() call anymore.
local parsers = {
  "javascript", "typescript", "go", "gomod", "gosum", "gowork", "gotmpl",
  "templ", "c", "lua", "vim", "vimdoc", "query", "markdown",
  "markdown_inline", "yaml",
}

-- Installs any missing parsers (async, no-op for already installed ones).
require("nvim-treesitter").install(parsers)

-- Highlighting is no longer a setup option; enable it per-buffer with
-- vim.treesitter.start(). It resolves the language from the filetype, so we
-- simply try to start it and ignore filetypes without a parser.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(ft)
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start(args.buf, lang)
      -- Optional: experimental treesitter-based indentation.
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
