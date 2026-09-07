local default_lsp_servers = {
    "lua_ls", "rust_analyzer"
}

return {
    'mason-org/mason-lspconfig.nvim',
    opts = {
        ---@type string[]
        ensure_installed = default_lsp_servers
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
