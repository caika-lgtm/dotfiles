local which_key = require("which-key")
local builtin = require("telescope.builtin")

-- LSP attach: buffer-local which-key mappings + format on save
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(event)
    local wk_opts = { buffer = event.buf }

    which_key.add({
      -- goto / hover
      { "gl",         vim.diagnostic.open_float,    desc = "Open diagnostic float" },
      { "K",          vim.lsp.buf.hover,            desc = "Show hover information" },

      -- diagnostics (common convention)
      { "[d",         vim.diagnostic.goto_prev,     desc = "Go to previous diagnostic" },
      { "]d",         vim.diagnostic.goto_next,     desc = "Go to next diagnostic" },

      -- LSP group
      { "<leader>l",  group = "LSP" },
      { "<leader>la", vim.lsp.buf.code_action,      desc = "Code action" },
      { "<leader>i",  vim.lsp.buf.code_action,      desc = "Code action" },
      { "<leader>lr", vim.lsp.buf.references,       desc = "References" },
      { "<leader>ln", vim.lsp.buf.rename,           desc = "Rename" },
      { "<leader>lw", vim.lsp.buf.workspace_symbol, desc = "Workspace symbol" },
      { "<leader>ld", vim.diagnostic.open_float,    desc = "Open diagnostic float" },
    }, wk_opts)
  end,
})

-- Global / non-LSP mappings
which_key.add({
  { "<leader>B", '<cmd>b#<CR>',                             desc = "Go to previous buffer" },
  { "<leader>p", '"_dP',                                    desc = "Paste without overwrite" },
  { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Toggle comment" },
  {
    "<leader>sR",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    desc = "Search and replace word under cursor",
  },

  { "J",     "mzJ`z",                                      desc = "Join lines and keep cursor position" },
  { "<C-d>", "<C-d>zz",                                    desc = "Half page down and center" },
  { "<C-u>", "<C-u>zz",                                    desc = "Half page up and center" },
  { "n",     "nzzzv",                                      desc = "Next search result and center" },
  { "N",     "Nzzzv",                                      desc = "Previous search result and center" },
  { "Q",     "<nop>",                                      desc = "Disable Ex mode" },

  { "vs",    '<cmd>vsplit | wincmd p | b# | wincmd p<CR>', desc = "Vertical Split",                     silent = true },
  { "hs",    '<cmd>split | wincmd p | b# | wincmd p<CR>',  desc = "Horizontal Split",                   silent = true },
  { "z0",    "<cmd>set foldlevel=0<cr>",                   desc = "Fold all" },
  { "z1",    "<cmd>set foldlevel=1<cr>",                   desc = "Fold level 1" },
  { "z2",    "<cmd>set foldlevel=2<cr>",                   desc = "Fold level 2" },
  { "z3",    "<cmd>set foldlevel=3<cr>",                   desc = "Fold level 3" },
  { "z4",    "<cmd>set foldlevel=4<cr>",                   desc = "Fold level 4" },
  { "z5",    "<cmd>set foldlevel=5<cr>",                   desc = "Fold level 5" },
  { "z6",    "<cmd>set foldlevel=6<cr>",                   desc = "Fold level 6" },
  { "z7",    "<cmd>set foldlevel=7<cr>",                   desc = "Fold level 7" },
  { "z8",    "<cmd>set foldlevel=8<cr>",                   desc = "Fold level 8" },
  { "z9",    "<cmd>set foldlevel=9<cr>",                   desc = "Fold level 9" },
})

-- Telescope
which_key.add({
  { "<leader>f",  group = "Find" },
  { "<leader>ff", builtin.find_files, desc = "Find files" },
  { "<leader>fg", builtin.git_files,  desc = "Find git files" },
  { "<leader>fl", builtin.live_grep,  desc = "Live grep" },
  { "<leader>fr", builtin.resume,     desc = "Resume" },

  { ";",          builtin.buffers,    desc = "Find buffers" },
})

-- Visual mode mappings
which_key.add({
  mode = { "v" },

  { "J",          ":m '>+1<CR>gv=gv",                       desc = "Move selection down" },
  { "K",          ":m '<-2<CR>gv=gv",                       desc = "Move selection up" },
  { "<leader>/",  "<Plug>(comment_toggle_linewise_visual)", desc = "Toggle comment" },
  { "<leader>gh", "<cmd>DiffviewFileHistory<CR>",           desc = "Git history" },
})

-- insert commands
vim.keymap.set("i", "<Right>", "<Right>", { noremap = true }) -- keep as-is

-- NvimTree
-- which_key.add({
--   { "<leader>t",  group = "Nvim-[T]ree" },
--   { "<leader>tt", "<cmd>NvimTreeToggle<CR>",   desc = "[T]oggle" },
--   { "<leader>tf", "<cmd>NvimTreeFindFile<CR>", desc = "[F]ind File" },
--   { "<leader>tr", "<cmd>NvimTreeRefresh<CR>",  desc = "[R]efresh" },
--   { "<leader>to", "<cmd>NvimTreeOpen<CR>",     desc = "[O]pen" },
--   { "<leader>tc", "<cmd>NvimTreeClose<CR>",    desc = "[C]lose" },
-- })

local function gitsigns_blame_toggle()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match("^gitsigns%-blame:") then
      pcall(vim.api.nvim_win_close, win, true)
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
      return
    end
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match("^gitsigns%-blame:") then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
  require("gitsigns").blame()
end

-- Git
which_key.add({
  { "<leader>g",   group = "[G]it" },
  { "<leader>gb",  gitsigns_blame_toggle,                         desc = "[b]lame" },
  { "<leader>gB",  function() Snacks.gitbrowse() end,             desc = "Git Browse",           mode = { "n", "v" } },
  { "<leader>glb", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "[L]ine [B]lame" },
  { "<leader>gp",  "<cmd>Gitsigns preview_hunk<CR>",              desc = "[P]review hunk" },
  { "<leader>gr",  "<cmd>Gitsigns reset_hunk<CR>",                desc = "[R]eset hunk" },
  { "<leader>gh",  "<cmd>Gitsigns nav_hunk next<CR>",             desc = "[H]unk next" },
  { "<leader>gH",  "<cmd>Gitsigns nav_hunk prev<CR>",             desc = "[H]unk prev" },
  { "<leader>gfh", "<cmd>DiffviewFileHistory %<CR>",              desc = "[F]ile [H]istory" },
  { "<leader>gdv", "<cmd>DiffviewOpen<CR>",                       desc = "[D]iff [V]iew" },
  { "<leader>gdr", "<cmd>DiffviewRefresh<CR>",                    desc = "[D]iff view [R]efresh" },
  { "<leader>gqf", "<cmd>Gitsigns setqflist all<CR>",             desc = "[Q]uick [F]ix list" },
})

-- Snacks
which_key.add({
  { "<leader><space>", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
  { "<leader>e",       function() Snacks.explorer() end,                     desc = "File Explorer" },
  { "<leader>n",       function() Snacks.picker.notifications() end,         desc = "Notification History" },
  { "<leader>:",       function() Snacks.picker.command_history() end,       desc = "Command History" },
  { "<leader>bd",      "<cmd>lua Snacks.bufdelete()<CR>",                    desc = "[B]uffer [D]elete" },
  { "<leader>bo",      "<cmd>lua Snacks.bufdelete.other()<CR>",              desc = "[B]uffer Delete [O]ther" },
  { "<leader>ba",      "<cmd>lua Snacks.bufdelete.all()<CR>",                desc = "[B]uffer Delete [A]ll" },
  { "<leader>sgl",     function() Snacks.picker.git_log() end,               desc = "Git Log" },
  { "<leader>sgL",     function() Snacks.picker.git_log_line() end,          desc = "Git Log Line" },
  { "<leader>sgf",     function() Snacks.picker.git_log_file() end,          desc = "Git Log File" },
  { "<leader>sgs",     function() Snacks.picker.git_status() end,            desc = "Git Status" },
  { "<leader>sgd",     function() Snacks.picker.git_diff() end,              desc = "Git Diff (Hunks)" },
  { '<leader>s"',      function() Snacks.picker.registers() end,             desc = "Registers" },
  { '<leader>s/',      function() Snacks.picker.search_history() end,        desc = "Search History" },
  { "<leader>sb",      function() Snacks.picker.lines() end,                 desc = "Buffer Lines" },
  { "<leader>sC",      function() Snacks.picker.commands() end,              desc = "Commands" },
  { "<leader>sd",      function() Snacks.picker.diagnostics() end,           desc = "Diagnostics" },
  { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,    desc = "Buffer Diagnostics" },
  { "<leader>sj",      function() Snacks.picker.jumps() end,                 desc = "Jumps" },
  { "<leader>sk",      function() Snacks.picker.keymaps() end,               desc = "Keymaps" },
  { "<leader>sl",      function() Snacks.picker.loclist() end,               desc = "Location List" },
  { "<leader>sm",      function() Snacks.picker.marks() end,                 desc = "Marks" },
  { "<leader>sq",      function() Snacks.picker.qflist() end,                desc = "Quickfix List" },
  { "<leader>sr",      function() Snacks.picker.resume() end,                desc = "Resume" },
  { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
  { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
  { "gd",              function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
  { "gD",              function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
  { "gr",              function() Snacks.picker.lsp_references() end,        nowait = true,                   desc = "References" },
  { "gi",              function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
  { "gy",              function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
  { "gai",             function() Snacks.picker.lsp_incoming_calls() end,    desc = "C[a]lls Incoming" },
  { "gao",             function() Snacks.picker.lsp_outgoing_calls() end,    desc = "C[a]lls Outgoing" },
  -- { "]]",              function() Snacks.words.jump(vim.v.count1) end,       desc = "Next Reference",        mode = { "n", "t" } },
  -- { "[[",              function() Snacks.words.jump(-vim.v.count1) end,      desc = "Prev Reference",        mode = { "n", "t" } },
})

-- Bufferline
which_key.add({
  { "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to buffer 1" },
  { "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to buffer 2" },
  { "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to buffer 3" },
  { "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to buffer 4" },
  { "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to buffer 5" },
  { "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to buffer 6" },
  { "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to buffer 7" },
  { "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to buffer 8" },
  { "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to buffer 9" },
})

-- from LazyVim
which_key.add({
  { "j",         "v:count == 0 ? 'gj' : 'j'",   desc = "Down",                   expr = true,                  silent = true,      mode = { "n", "x" } },
  -- { "<Down>",    "v:count == 0 ? 'gj' : 'j'",   desc = "Down",                   expr = true,                  silent = true,      mode = { "n", "x" } },
  { "k",         "v:count == 0 ? 'gk' : 'k'",   desc = "Up",                     expr = true,                  silent = true,      mode = { "n", "x" } },
  -- { "<Up>",      "v:count == 0 ? 'gk' : 'k'",   desc = "Up",                     expr = true,                  silent = true,      mode = { "n", "x" } },

  -- { "<C-h>",     "<C-w>h",                      desc = "Go to Left Window",      remap = true,                 mode = "n" },
  { "<Left>",    "<C-w>h",                      desc = "Go to Left Window",      remap = true,                 mode = "n" },
  -- { "<C-j>",     "<C-w>j",                      desc = "Go to Lower Window",     remap = true,                 mode = "n" },
  { "<Down>",    "<C-w>j",                      desc = "Go to Lower Window",     remap = true,                 mode = "n" },
  -- { "<C-k>",     "<C-w>k",                      desc = "Go to Upper Window",     remap = true,                 mode = "n" },
  { "<Up>",      "<C-w>k",                      desc = "Go to Upper Window",     remap = true,                 mode = "n" },
  -- { "<C-l>",     "<C-w>l",                      desc = "Go to Right Window",     remap = true,                 mode = "n" },
  { "<Right>",   "<C-w>l",                      desc = "Go to Right Window",     remap = true,                 mode = "n" },

  { "<M-Down>",  "<cmd>resize +2<cr>",          desc = "Increase Window Height", mode = "n" },
  { "<M-Up>",    "<cmd>resize -2<cr>",          desc = "Decrease Window Height", mode = "n" },
  { "<M-Right>", "<cmd>vertical resize -2<cr>", desc = "Decrease Window Width",  mode = "n" },
  { "<M-Left>",  "<cmd>vertical resize +2<cr>", desc = "Increase Window Width",  mode = "n" },

  { "n",         "'Nn'[v:searchforward].'zv'",  expr = true,                     desc = "Next Search Result",  mode = "n" },
  { "n",         "'Nn'[v:searchforward]",       expr = true,                     desc = "Next Search Result",  mode = { "x", "o" } },
  { "N",         "'nN'[v:searchforward].'zv'",  expr = true,                     desc = "Prev Search Result",  mode = "n" },
  { "N",         "'nN'[v:searchforward]",       expr = true,                     desc = "Prev Search Result",  mode = { "x", "o" } },

  { "<C-s>",     "<cmd>w<cr><esc>",             desc = "Save File",              mode = { "i", "x", "n", "s" } },

  { "<",         "<gv",                         desc = "Indent Left",            mode = "x" },
  { ">",         ">gv",                         desc = "Indent Right",           mode = "x" },
})
