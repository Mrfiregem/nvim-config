return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show { global = true }
            end,
            desc = "Show all keymaps (which-key)",
        },
        {
            "<localleader>?",
            function()
                require("which-key").show { global = false }
            end,
            desc = "Show buffer-local keymaps (which-key)",
        },
    },
}
