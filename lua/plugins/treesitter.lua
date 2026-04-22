---@alias TSSpec {ext: string, parser: string}

---@type (string|TSSpec)[]
local ts_specs = { "lua", "nu" }

---Convert strings to { ext: string, parser: string } format
---@param s string|TSSpec
---@return TSSpec
local str_to_map = function(s)
    local ty = type(s)
    if ty == "table" then
        return s
    elseif ty == "string" then
        return { ext = s, parser = s }
    else
        error("Expected type (string|table), got " .. ty)
    end
end

local tsspec_validator = function(s)
    if type(s) ~= "table" then return nil end
    return type(s.ext) == "string" and type(s.parser) == "string"
end

---Enable treesitter functionality for the listed parsers
---@param specs string[] List of treesitter parser specs to enable
local enable_specs = function(specs)
    vim.validate("specs", specs, "table")
    local group = vim.api.nvim_create_augroup("ts.enable", {})

    for spec in vim.iter(specs):map(str_to_map) do
        vim.validate("spec", spec, tsspec_validator, "TSSpec")
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = spec.ext,
            callback = function(ev)
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
