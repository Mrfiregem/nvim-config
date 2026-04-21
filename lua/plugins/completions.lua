local snippets = {
    "nvim-mini/mini.snippets",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        local gen_loader = require("mini.snippets").gen_loader
        require("mini.snippets").setup {
            snippets = { gen_loader.from_lang() },
        }
    end,
}

return {
    "nvim-mini/mini.completion",
    event = "BufRead",
    dependencies = { snippets, "mini.icons" },
    opts = {},
}
