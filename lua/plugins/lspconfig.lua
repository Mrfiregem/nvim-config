local lsp_servers = {
    "lua_ls",
    "rust_analyzer",
}

local formatters = {
    "stylua",
}

vim.list_extend(lsp_servers, formatters)

local lspconfig = {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    opts = {
        ensure_installed = lsp_servers,
    },
}

local lazydev = {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
        library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}

return {
    lspconfig,
    lazydev,
}
