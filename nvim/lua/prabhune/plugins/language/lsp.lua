return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- BlinkCMP
      "saghen/blink.cmp",
      {
        --- LuaLS ---
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua filetypes
        opts = {
          library = {
            -- see the configuration section for more details
            -- load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },

    config = function()
      -- "hey Lua LSP I know how to do a bunch of stuff you might
      -- not have known that I knew how to do" vvv
      -- get capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- lua language server (brew install lsp-language-server)
      vim.lsp.config["lua_ls"] = { capabilities = capabilities } -- set capabilities
      vim.lsp.enable("lua_ls")                                -- enable for all lua files

      -- autocmd: start treesitter when any file opens (required for treesitter main branch)
      -- required for FANCY and SPICY syntax highlighting
      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          vim.treesitter.start()
        end,
      })

      -- key configuration entry point for determining what an lsp should do
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp", {}),

        -- called every time we attach a file and language server
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          -- FIX: resolve the Position Encoding Warning (UTF-8 vs UTF-16)
          -- Ruff uses UTF-8, Pyright/Copilot often default to UTF-16.
          if client.name == "ruff" then
            -- disable Ruff's hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
        end,
      })
    end,
  },
}
