return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- BlinkCMP
      "saghen/blink.cmp",
      {
        --- LuaLS --
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
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- lua language server (brew install lsp-language-server)
      vim.lsp.config['lua_ls'] = { capabilities = capabilities } -- set capabilities
      vim.lsp.enable('lua_ls')                                   -- enable for all lua files

      -- autocmd: start treesitter when any file opens (required for treesitter main branch)
      -- required for FANCY and SPICY syntax highlighting
      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          vim.treesitter.start()
        end,
      })

      -- key configuration entry point for determining what an lsp should do
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my.lsp', {}),

        -- called every time we attach a file and language server
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          --- AUTO FORMATTING on save

          -- does client actually support formatting
          if client:supports_method('textDocument/formatting') then
            -- create autocmd
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),

              -- only listen to LSPs inside current buffer (e.g., don't do lua lsp inside c file)
              buffer = args.buf,
              -- runs lsp formatting for current buffer
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
              end,
            })
          end
        end,
      })
    end,
  }
}
