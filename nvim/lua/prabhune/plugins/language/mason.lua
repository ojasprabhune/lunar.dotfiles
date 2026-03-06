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
      -- called for each installed server
      function(server_name)
        require('lspconfig')[server_name].setup({})
      end,
    },
  }
}
