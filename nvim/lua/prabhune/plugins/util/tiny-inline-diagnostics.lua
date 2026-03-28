return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  opts = {
    multilines = {
      enabled = true,
    },
    overflow = {
      mode = "wrap",
    },
    show_all_diags_on_cursorline = true,
  },
}
