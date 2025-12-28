return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  version = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "c", "lua", "vim", "vimdoc",
      "elixir", "javascript", "html",
      "python", "typescript", "markdown", "markdown_inline", "bash"
    },
    highlight = { enable = true },
    indent = { enable = true },
    folds = { enable = true },
  },
}
