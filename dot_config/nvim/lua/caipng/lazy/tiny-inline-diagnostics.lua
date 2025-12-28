return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      options = {
        show_all_diags_on_cursorline = true,
        multilines = {
          enabled = true,
        },
        show_source = {
          enabled = true,
          if_many = true,
        },
      },
    })
    vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
  end,
}
