---@module "lazy"
---@type LazyPluginSpec
local oil = {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    lazy = false,
    keys = {
        {
            "<leader>f",
            function()
                require("oil").toggle_float()
            end,
            desc = "Open floating Oil buffer",
        },
    },
}

---@type LazyPluginSpec
local snipe = {
    "leath-dub/snipe.nvim",
    keys = {
        {
            "gb",
            function()
                require("snipe").open_buffer_menu()
            end,
            desc = "Open Snipe buffer menu",
        },
    },
    opts = {},
}

---@type LazySpec
return {
    oil,
    snipe,
}
