-- calls vim API, "g" globals, and mapleader maps key to spacebar
vim.g.mapleader = " "

require("prabhune.config.lazy_init")
require("prabhune.config.set")
require("prabhune.config.keymaps")
