return {
  'nvim-telescope/telescope.nvim',
  tag = 'v0.2.0',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "flex",
        layout_config = {
          horizontal = { preview_cutoff = 80, preview_width = 0.55 },
          vertical = { mirror = true, preview_cutoff = 25 },
          prompt_position = "top",
          width = 0.87,
          height = 0.80,
        },
        mappings = {
          i = {
            ["<C-q>"] = function(prompt_bufnr)
              actions.smart_send_to_qflist(prompt_bufnr)
              vim.schedule(function()
                require("trouble").open({ mode = "qflist", focus = true })
              end)
            end,
          },
          n = {
            ["<C-q>"] = function(prompt_bufnr)
              actions.smart_send_to_qflist(prompt_bufnr)
              vim.schedule(function()
                require("trouble").open({ mode = "qflist", focus = true })
              end)
            end,
          },
        },
      },
    })
  end
}
