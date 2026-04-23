return {
    "stevearc/oil.nvim",
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    lazy = false,
    opts = {},
    cmd = "Oil",
    keys = {
        {
            "<Leader>f",
            function()
                require("oil").toggle_float()
            end,
            desc = "Toggle floating Oil file explorer",
        },
    },
}
