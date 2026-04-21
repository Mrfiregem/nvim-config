local ts_specs = { "lua", "nu" }

---Enable treesitter functionality for the listed parsers
---@param specs string[] List of treesitter parser specs to enable
local enable_specs = function(specs)
    vim.validate("specs", specs, "table")
    local group = vim.api.nvim_create_augroup("util.ts.enable", {})

    for spec in vim.iter(specs) do
        vim.validate("spec", spec, "string")
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = spec,
            callback = function(ev)
                vim.treesitter.start(ev.buf, spec)
            end,
        })
    end
end

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        enable_specs(ts_specs)
    end,
}
