return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      -- You can also load snippets from other sources, like Lua files:
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/prabhune/snippets" })
    end,
  },
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
}
