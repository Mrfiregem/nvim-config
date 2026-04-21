local lsp_servers = {
    "lua_ls",
    "nushell",
    "rust_analyzer",
}

return {
    "neovim/nvim-lspconfig",
    config = function()
        vim.lsp.enable(lsp_servers)
    end,
}
