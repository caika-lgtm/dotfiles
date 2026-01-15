return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
    "onsails/lspkind.nvim",
  },
  config = function()
    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "ts_ls",
        "lua_ls",
        "marksman",
        "basedpyright",
        "taplo",
        "bashls",
      },
    })

    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    vim.lsp.config("bashls", {
      filetypes = { "sh", "zsh", "zshrc", "bash", "bashrc" },
    })

    vim.lsp.config("ruff", {
      root_dir = function(bufnr, on_dir)
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name:match("^diffview://") then
          return
        end
        local root = vim.fs.root(name, {
          "pyproject.toml",
          "ruff.toml",
          ".ruff.toml",
          "setup.cfg",
          "tox.ini",
          ".git",
        })
        on_dir(root or vim.fn.getcwd())
      end,
      on_attach = function(client, bufnr)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
      end
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim", "love" } },
          workspace = { library = { vim.env.VIMRUNTIME } },
        },
      },
    })

    vim.lsp.enable({
      "ts_ls",
      "lua_ls",
      "ruff",
      "marksman",
      "basedpyright",
      "taplo",
      "bashls",
    })

    local cmp = require('cmp')
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    -- this is the function that loads the extra snippets to luasnip
    -- from rafamadriz/friendly-snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({
      window = {
        documentation = {
          border = 'rounded'
        },
      },
      sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer',  keyword_length = 3 },
      },
      mapping = cmp.mapping.preset.insert({
        -- ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        -- ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        -- ['<C-Space>'] = cmp.mapping.complete(),
      }),
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
    })

    require('lspkind').init({
      mode = 'symbol_text',
    })
  end
}
