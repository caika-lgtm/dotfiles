return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      symbols = {             -- Configure symbols mode
        win = {
          type = "split",     -- split window
          relative = "win",   -- relative to current window
          position = "right", -- right side
          size = 0.3,         -- 30% of the window
        },
      },
    },
    -- modes = {
    --   diagnostics = { auto_open = true },
    -- },
    auto_close = true,
    auto_preview = true,
    follow = true,
    auto_refresh = false,
    focus = true,
    win = {
      type = "split",     -- split window
      relative = "win",   -- relative to current window
      position = "right", -- right side
      size = 0.3,         -- 30% of the window
    },
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=true<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=true win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
}
