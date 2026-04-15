-- Basic options
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

local util = require("util")

-- Custom user command to update all or specified packages
vim.api.nvim_create_user_command("PackUpdate", function(args)
    local names = nil
    if #args.fargs > 0 then names = args.fargs end
    vim.pack.update(names, { force = args.bang })
end, { desc = "Update vim.pack plugins", bang = true, nargs = "*", complete = util.pack.cmdline_completer })

vim.api.nvim_create_user_command("PackPrune", function()
    vim.pack.del(vim.iter(vim.pack.get())
        :filter(function(x)
            return not x.active
        end)
        :map(function(x)
            return x.spec.name
        end)
        :totable())
end, { desc = "Remove inactive (removed) vim.pack plugins" })

-- Enable builtin plugins
local builtin_plugins = { "nohlsearch", "nvim.undotree" }
for plugin in vim.iter(builtin_plugins) do
    vim.cmd.packadd(plugin)
end

-- Install & enable listed plugins from url
util.pack.use {
    { src = "https://github.com/neovim/nvim-lspconfig", build = "TSUpdate" },
    "https://github.com/nvim-treesitter/nvim-treesitter",
    { src = "https://github.com/ibhagwan/fzf-lua", opts = {} },
    { src = "https://github.com/folke/lazydev.nvim", opts = {} },
    {
        src = "https://github.com/ember-theme/nvim",
        name = "ember",
        opts = { variant = "ember" },
        config = function()
            vim.cmd.colorscheme("ember")
        end,
    },
    {
        src = "https://github.com/stevearc/oil.nvim",
        opts = {},
        depends = { "https://github.com/nvim-tree/nvim-web-devicons" },
    },
}

-- Enable LSP server configurations from `lspconfig`
local lsp_servers = { "nushell", "lua_ls" }
vim.lsp.enable(lsp_servers)

-- Enable treesitter highlighting
local ts_specs = { "nu", "lua" }
util.treesitter.enable(ts_specs)
