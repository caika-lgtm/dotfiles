return {
  'piersolenski/import.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  opts = {
    picker = "telescope",
  },
  keys = {
    {
      "<leader>I",
      function()
        require("import").pick()
      end,
      desc = "Import",
    },
  },
}
