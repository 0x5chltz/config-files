-- Neovim 0.11+ LSP configuration (NO lspconfig.setup, NO setup_handlers)

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },

  config = function()
    ------------------------------------------------------------------
    -- LSP ATTACH KEYMAPS (ini bagian kamu, SUDAH BENAR)
    ------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
      end,
    })

    ------------------------------------------------------------------
    -- CAPABILITIES
    ------------------------------------------------------------------
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    ------------------------------------------------------------------
    -- DISABLE DIAGNOSTICS (seperti config kamu)
    ------------------------------------------------------------------
    local no_diagnostics = {
      ["textDocument/publishDiagnostics"] = function() end,
    }

    ------------------------------------------------------------------
    -- LSP SERVER CONFIG (NEW API)
    ------------------------------------------------------------------

    vim.lsp.config.lua_ls = {
      capabilities = capabilities,
      handlers = no_diagnostics,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
        },
      },
    }

    vim.lsp.config.pylsp = {
      capabilities = capabilities,
      handlers = no_diagnostics,
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = { enabled = true },
            pyflakes = { enabled = true },
            pylint = { enabled = true },
            mccabe = { enabled = true },
            rope_completion = { enabled = true },
          },
        },
      },
    }

    vim.lsp.config.clangd = {
      capabilities = capabilities,
      handlers = no_diagnostics,
      settings = {
        clangd = {
          fallbackFlags = { "-std=c11" },
        },
      },
    }

    vim.lsp.config.rust_analyzer = {
      capabilities = capabilities,
      handlers = no_diagnostics,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          checkOnSave = { command = "clippy" },
        },
      },
    }

    ------------------------------------------------------------------
    -- ENABLE SERVERS (INI PENGGANTI setup_handlers)
    ------------------------------------------------------------------
    vim.lsp.enable({
      "lua_ls",
      "pylsp",
      "clangd",
      "rust_analyzer",
    })
  end,
}
