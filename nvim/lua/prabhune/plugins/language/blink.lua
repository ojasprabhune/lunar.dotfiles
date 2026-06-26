return {
	"saghen/blink.cmp",
	version = "1.*",

	dependencies = {
		"rafamadriz/friendly-snippets",
		"L3MON4D3/LuaSnip",
	},

	opts = {
		keymap = { preset = "super-tab" },

		appearance = {
			nerd_font_variant = "mono",
		},

		snippets = {
			preset = "luasnip",
		},

		signature = {
			enabled = true,
		},

		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
	},
}
