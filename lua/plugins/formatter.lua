return {
    "stevearc/conform.nvim",
    ---@type conform.setupOpts
    opts = {
        format_on_save = {
            lsp_format = "fallback",
        },
        formatters_by_ft = {
            lua = { "stylua" },
        },
    },
    config = function(pkg)
        require("conform").setup(pkg.opts)

        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                require("conform").format { bufnr = args.buf }
            end,
        })
    end,
}
