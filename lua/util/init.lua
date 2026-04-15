---@class TSSpec
---@field name string The name of the treesitter parser
---@field ext string The extension to enable queries for

local T = {}

---@param spec TSSpec The name of a treesitter parser and the extension of the file
local spec_validator = function(spec)
    if type(spec) == "table" then
        local keys = vim.tbl_keys(spec)
        table.sort(keys)
        return vim.deep_equal(keys, { "ext", "name" })
    end
    return false
end

---Enable treesitter functionality for the given parsers
---@param specs (string|TSSpec)[] A list of treesitter parser specs to enable
T.enable = function(specs)
    vim.validate("specs", specs, "table", false, "(string|TSSpec)[]")
    local group = vim.api.nvim_create_augroup('util.ts.enable', {})
    vim.iter(specs)
        :map(function(spec) -- Convert strings to dict format
            if type(spec) == "string" then
                return { name = spec, ext = spec }
            else
                return spec
            end
        end)
        :each(function(spec) -- Enable treesitter in buffer for language
            vim.validate("spec", spec, spec_validator, "TSSpec")
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = spec.ext,
                callback = function(event)
                    vim.treesitter.start(event.buf, spec.lang)
                end,
            })
        end)
end

local M = {
    pack = require("util.pack"),
    treesitter = T,
}

return M
