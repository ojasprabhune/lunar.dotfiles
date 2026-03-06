return {
  "rachartier/tiny-code-action.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    -- optional picker via telescope
    { "nvim-telescope/telescope.nvim" },
  },
  event = "LspAttach",
  opts = {},
}
