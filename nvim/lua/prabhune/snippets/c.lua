local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- Example: simple "hello" snippet
  s("hello", {
    t("Hello, world!"),
  }),

  -- Example: function snippet
  s("fn", {
    t("function "), i(1, "name"), t("()"),
    t({ "", "  " }), i(2, "-- body"),
    t({ "", "end" }),
  }),
}
