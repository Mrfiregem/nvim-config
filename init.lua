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

-- Enable builtin plugins
local builtin_plugins = { "nohlsearch", "nvim.undotree" }
for plugin in vim.iter(builtin_plugins) do
    vim.cmd.packadd(plugin)
end

-- Add code that should be run when packages are installed, updated, or deleted
util.pack.run_on_build("nvim-treesitter", "TSUpdate") -- Update treesitter parsers after updating package
util.pack.run_on_build("telescope-fzf-native.nvim", "make") -- Build package

-- Install & enable listed plugins from url
vim.pack.add {
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-lua/plenary.nvim", -- telescope dependency
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim", -- telescope dependency
    { src = "https://github.com/nvim-telescope/telescope.nvim", version = vim.version.range("*") },
    "https://github.com/folke/lazydev.nvim",
    { src = "https://github.com/ember-theme/nvim", name = "ember" },
}

-- Load colorscheme
util.pack.configure_pkg("ember", function()
    require("ember").setup { variant = "ember" }
    vim.cmd.colorscheme("ember")
end)

-- Configure packages
util.pack.configure_pkg("lazydev.nvim", {})

-- Enable LSP server configurations from `lspconfig`
local lsp_servers = { "nushell", "lua_ls" }
vim.lsp.enable(lsp_servers)

-- Enable treesitter highlighting
local ts_specs = { "nu", "lua" }
util.treesitter.enable(ts_specs)
