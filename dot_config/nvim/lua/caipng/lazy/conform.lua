return {
  'stevearc/conform.nvim',
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      markdown = { "prettierd" },
      python = {
        "ruff_fix",        -- To fix auto-fixable lint errors (e.g., organize imports)
        "ruff_format",     -- To run the Ruff formatter
      },
    },
    -- Set default options
    default_format_ops = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    format_on_save = {
      timeout_ms = 500
    }
  }
}
