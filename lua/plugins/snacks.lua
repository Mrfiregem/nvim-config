return {
    "folke/snacks.nvim",
    -- Load before other plugins
    priority = 1000,
    lazy = false,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
        git = { enabled = true },
        gh = { enabled = true },
        lazygit = { enabled = true },
        indent = { enabled = true },
        scratch = { enabled = true },
    },
    keys = {
        {
            "<leader>.",
            function()
                Snacks.scratch()
            end,
            desc = "Toggle Scratch Buffer",
        },
        {
            "<leader>S",
            function()
                Snacks.scratch.select()
            end,
            desc = "Select Scratch Buffer",
        },
        {
            "<leader>gg",
            function()
                Snacks.lazygit()
            end,
            desc = "Lazygit",
        },
        {
            "<leader>gi",
            function()
                Snacks.picker.gh_issue()
            end,
            desc = "Github Issues (open)",
        },
        {
            "<leader>gI",
            function()
                Snacks.picker.gh_issue { state = "all" }
            end,
            desc = "Github Issues (all)",
        },
        {
            "<leader>gp",
            function()
                Snacks.picker.gh_pr()
            end,
            desc = "Github Pull Requests (open)",
        },
        {
            "<leader>gP",
            function()
                Snacks.picker.gh_pr { state = "all" }
            end,
            desc = "Github Pull Requests (all)",
        },
    },
}
