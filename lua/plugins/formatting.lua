---@module "lazy"
---@type LazyPluginSpec
return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<localleader>f",
            function()
                require("conform").format({ async = true })
            end,
        },
        mode = { "n", "i" },
        desc = "Format buffer",
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff" },
            javascript = { "prettierd", "prettier", "biome", stop_after_first = true },
            typescript = { "prettierd", "prettier", "biome", stop_after_first = true },
            ["_"] = { "trim_whitespace", "trim_newlines" },
        },
        default_format_opts = { lsp_format = "fallback" },
        format_on_save = { timeout_ms = 500 },
        formatters = {
            stylua = {
                append_args = {
                    "--indent-width",
                    tostring(vim.o.shiftwidth),
                    "--indent-type",
                    vim.o.expandtab and "Spaces" or "Tabs",
                },
            },
        },
    },
}
