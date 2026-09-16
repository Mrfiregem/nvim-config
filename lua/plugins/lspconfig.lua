---@type string[]
local lsp_servers = {
    "emmet_language_server",
    "lua_ls",
    "rust_analyzer",
}

---@type string[]
local formatters = {
    "ruff",
    "stylua",
}

vim.list_extend(lsp_servers, formatters)

---@module "lazy"
---@type LazyPluginSpec
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

---@type LazyPluginSpec
local lazydev = {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    ---@module "lazydev"
    ---@type lazydev.Config
    opts = {
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}

---@type LazySpec
return {
    lspconfig,
    lazydev,
}
