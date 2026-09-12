---@module "lazy"
---@type LazyPluginSpec
return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {},
}
