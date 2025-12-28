return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = "VeryLazy",
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  },
  config = function()
    vim.opt.termguicolors = true
    require('bufferline').setup {
      options = {
        close_command = function(n) Snacks.bufdelete(n) end,
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        indicator = {
          style = 'underline',
        },
        separator_style = "thick",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        numbers = "ordinal",
        number_style = "superscript",
        offsets = {
          -- {
          --   filetype = "NvimTree",
          --   text = "NvimTree",
          --   highlight = "Directory",
          --   text_align = "center",
          --   separator = true
          -- },
          {
            filetype = "snacks_layout_box",
          },
        },
      }
    }
  end
}
