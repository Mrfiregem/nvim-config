return {
    "stevearc/oil.nvim",
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    opts = {},
    cmd = "Oil",
    keys = {
        {
            "<Leader>f",
            function()
                require("oil").toggle_float()
            end,
        },
    },
}
