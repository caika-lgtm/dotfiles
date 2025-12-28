-- return {
--   'nvim-lualine/lualine.nvim',
--   opts = function(_, opts)
--     local trouble = require("trouble")
--     local symbols = trouble.statusline({
--       mode = "lsp_document_symbols",
--       groups = {},
--       title = false,
--       filter = { range = true },
--       format = "{kind_icon}{symbol.name:Normal}",
--       -- The following line is needed to fix the background color
--       -- Set it to the lualine section you want to use
--       hl_group = "lualine_c_normal",
--     })
--     opts.sections = opts.sections or {}
--     opts.sections.lualine_c = opts.sections.lualine_c or {}
--     table.insert(opts.sections.lualine_c, {
--       symbols.get,
--       cond = symbols.has,
--     })
--   end,
-- }
--

local function uv()
  return vim.uv or vim.loop
end

local function normalize(path)
  if vim.fs and vim.fs.normalize then
    return vim.fs.normalize(path)
  end
  return (path:gsub("\\", "/"))
end

local function buf_path()
  local p = vim.fn.expand("%:p")
  return p ~= "" and normalize(p) or ""
end

local function buf_dir()
  local p = buf_path()
  if p == "" then
    return ""
  end
  return normalize(vim.fn.fnamemodify(p, ":h"))
end

local function lsp_root_for_buf()
  local bufnr = vim.api.nvim_get_current_buf()
  local p = buf_path()
  if p == "" then
    return nil
  end

  local clients = vim.lsp.get_clients
      and vim.lsp.get_clients({ bufnr = bufnr })
      or vim.lsp.get_active_clients({ bufnr = bufnr })

  local best
  for _, c in ipairs(clients or {}) do
    local root = c.config and c.config.root_dir
    if type(root) == "string" and root ~= "" then
      root = normalize(root)
      if p:find(root, 1, true) == 1 then
        if not best or #root > #best then
          best = root
        end
      end
    end
  end
  return best
end

local function git_root(start_dir)
  start_dir = (start_dir ~= "" and start_dir) or normalize(uv().cwd())

  if vim.fs and vim.fs.find then
    local gitdir = vim.fs.find(".git", { path = start_dir, upward = true })[1]
    if gitdir then
      return normalize(vim.fn.fnamemodify(gitdir, ":h"))
    end
  end

  -- fallback if vim.fs.find isn't available / doesn't work
  local out = vim.fn.systemlist({ "git", "-C", start_dir, "rev-parse", "--show-toplevel" })
  if vim.v.shell_error == 0 and out and out[1] and out[1] ~= "" then
    return normalize(out[1])
  end
end

local function project_root()
  return lsp_root_for_buf() or git_root(buf_dir()) or normalize(uv().cwd())
end

local function cwd()
  return normalize(uv().cwd())
end

local function format(component, text, hl_group)
  if not hl_group then
    return text
  end

  component.hl_cache = component.hl_cache or {}
  local lualine_hl_group = component.hl_cache[hl_group]
  if not lualine_hl_group then
    local utils = require("lualine.utils.utils")
    local mygui = function()
      local mybold = utils.extract_highlight_colors(hl_group, "bold") and "bold"
      local myitalic = utils.extract_highlight_colors(hl_group, "italic") and "italic"
      if mybold and myitalic then
        return mybold .. "," .. myitalic
      elseif mybold then
        return mybold
      elseif myitalic then
        return myitalic
      else
        return ""
      end
    end

    lualine_hl_group = component:create_hl({
      fg = utils.extract_highlight_colors(hl_group, "fg"),
      gui = mygui(),
    }, "LV_" .. hl_group)

    component.hl_cache[hl_group] = lualine_hl_group
  end

  return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
end

local function pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd", -- "cwd" or "root"
    modified_hl = "MatchParen",
    filename_hl = "Bold",
    dirpath_hl = "Conceal",
  }, opts or {})

  return function(self)
    local path = buf_path()
    if path == "" then
      return ""
    end

    local root = project_root()
    local cur = cwd()

    if opts.relative == "cwd" and path:find(cur, 1, true) == 1 then
      path = path:sub(#cur + 2)
    elseif path:find(root, 1, true) == 1 then
      path = path:sub(#root + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]", { trimempty = true })

    if #parts > 3 then
      parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
    end

    if opts.modified_hl and vim.bo.modified then
      parts[#parts] = format(self, parts[#parts], opts.modified_hl)
    else
      parts[#parts] = format(self, parts[#parts], opts.filename_hl)
    end

    local dirpath = ""
    if #parts > 1 then
      dirpath = table.concat(vim.list_slice(parts, 1, #parts - 1), sep)
      dirpath = format(self, dirpath .. sep, opts.dirpath_hl)
    end

    return dirpath .. parts[#parts]
  end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return {
        options = {
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              function() return "" end,
              padding = { left = 1, right = 0 },
              separator = "",
            },
            "mode",
          },
          lualine_b = { "branch", "diagnostics" },
          lualine_c = { { pretty_path() } },
          -- lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_x = { "diff", "filetype" },
          lualine_y = { "progress" },
          lualine_z = {
            { "location", separator = "" },
            {
              function() return "" end,
              padding = { left = 0, right = 1 },
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },
}
