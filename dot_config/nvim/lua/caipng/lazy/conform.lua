return {
  'stevearc/conform.nvim',
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      markdown = { "prettierd" },
      python = {
        "ruff_organize_imports",
        "ruff_fix",
        "ruff_format",
      },
      zsh = { "beautysh" },
      zshrc = { "beautysh" },
      bash = { "beautysh" },
      bashrc = { "beautysh" },
    },
    format_after_save = {
      lsp_format = "fallback",
    }
  }
}
