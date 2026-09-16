---@module "lazy.nvim"
---@param name string The name of the mini package
---@param o? LazyPluginSpec Other options
---@return LazyPluginSpec
local function mini(name, o)
    local options = vim.tbl_deep_extend("force", { opts = {}, version = false }, o or {})
    return vim.tbl_deep_extend("keep", { string.format("nvim-mini/mini.%s", name) }, options)
end

return {
    mini("pairs", { event = { "InsertEnter" } }),
    mini("surround", { keys = { "sa", "sd", "sf", "sF", "sh", "sr" } }),
}
