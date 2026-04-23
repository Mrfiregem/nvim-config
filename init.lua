-- Enable lazy.nvim plugin manager
require("config.lazy")

-- Enable builtin plugins
local builtin_plugins = { "nohlsearch", "nvim.undotree" }
for plugin in vim.iter(builtin_plugins) do
    vim.cmd.packadd(plugin)
end
