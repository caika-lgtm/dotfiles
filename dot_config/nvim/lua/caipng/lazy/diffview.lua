return {
  'sindrets/diffview.nvim',
  opts = {
    view = {
      default = {
        disable_diagnostics = true,
        winbar_info = true,
      },
      merge_tool = {
        disable_diagnostics = true,
        layout = "diff4_mixed"
      },
      file_history = {
        disable_diagnostics = true,
      }
    }
  }
}
