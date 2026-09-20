---@type string[]
local ensure_installed = {
    -- LSP servers
    "emmet_language_server",
    "lua_ls",
    "rust_analyzer",
    "nushell",
    -- Formatters
    "ruff",
    "stylua",
}

---@module "lazy"
---@type LazyPluginSpec
local lspconfig = {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    ---@type MasonSettings
    opts = {
        ensure_installed = ensure_installed,
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
