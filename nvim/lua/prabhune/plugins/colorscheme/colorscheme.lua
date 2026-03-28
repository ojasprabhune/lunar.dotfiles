-- return {
--   "ellisonleao/gruvbox.nvim",
--   priority = 1000,
--   config = true,
--   opts = {
--     transparent_mode = true,
--   },
-- }

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
}

-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   priority = 1000,
--   opts = {
--     flavour = "mocha",
--     transparent_background = true,
--     auto_integrations = true,
--     float = {
--       transparent = true, -- enable transparent floating windows
--     },
--   },
-- }

-- return {
--   "rebelot/kanagawa.nvim"
-- }
