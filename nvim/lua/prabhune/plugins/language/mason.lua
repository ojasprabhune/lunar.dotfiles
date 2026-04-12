return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    handlers = {
      -- this function runs for every installed server
      function(server_name)
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- specific configuration for Pyright
        if server_name == "pyright" then
          require("lspconfig").pyright.setup({
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  autoImportCompletions = true,
                  typeCheckingMode = "basic",
                  diagnosticMode = "workspace",
                  -- this helps Pyright find libraries in research envs
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                },
              },
            },
          })

          -- default configuration for everything else (clangd, jdtls, etc.)
        else
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end
      end,
    },
  },
}
