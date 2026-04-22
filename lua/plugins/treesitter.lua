---@alias TSSpec string|{ext: string, parser: string}

---@type TSSpec[]
local ts_specs = { "lua", "nu" }

---Enable treesitter functionality for the listed parsers
---@param specs TSSpec[] List of treesitter parser specs to enable
local enable_specs = function(specs)
    vim.validate("specs", specs, "table")
    local group = vim.api.nvim_create_augroup("ts.enable", {})

    for spec in vim.iter(specs) do
        local ext, parser = spec.ext or spec, spec.parser or spec
        vim.validate("ext", ext, "string")
        vim.validate("parser", parser, "string")

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = spec.ext,
            callback = function(ev)
                require("nvim-treesitter").install(parser):wait(300000) -- 5 mins
                vim.treesitter.start(ev.buf, spec.parser)
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
