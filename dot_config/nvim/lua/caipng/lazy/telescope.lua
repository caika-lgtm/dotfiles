return {
  'nvim-telescope/telescope.nvim',
  tag = 'v0.2.0',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local trouble = require("trouble")

    -- If bufnr isn't the prompt buffer, actions.close() can't find the picker.
    local function close_picker_safely(bufnr)
      local prompt_bufnr = bufnr

      local ok, picker = pcall(action_state.get_current_picker, bufnr)
      if ok and picker and picker.prompt_bufnr then
        prompt_bufnr = picker.prompt_bufnr
      else
        -- fallback: current buffer (usually the prompt buffer when you press the mapping)
        prompt_bufnr = vim.api.nvim_get_current_buf()
      end

      pcall(actions.close, prompt_bufnr)
    end

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
            ["<C-x>"] = function(bufnr)
              actions.smart_send_to_qflist(bufnr)
              close_picker_safely(bufnr)

              -- schedule is a nice “don’t fight window changes” safeguard
              vim.schedule(function()
                trouble.open("qflist")
              end)
            end,
          },
        },
      },
    })
  end
}
