local M = {
    pack = {},
    treesitter = {},
}

---Get list of packages not already present on commandline
---@param current string The current token being completed
---@param cmdline string The entire cmdline of the call
---@return string[] packages Matching package names
M.pack.cmdline_completer = function(current, cmdline)
    local input_args = vim.split(cmdline, "%s+", { trimempty = true })

    return vim.iter(vim.pack.get())
        :map(function(pack)
            return pack.spec.name
        end)
        :filter(function(name)
            return (not vim.list_contains(input_args, name) and vim.startswith(name, current))
        end)
        :totable()
end

---@param tbl string[]
local on_change_validator = function(tbl)
    return type(tbl) == "table"
        and vim.iter(tbl):all(function(val)
            return vim.list_contains({ "install", "update", "delete" }, val)
        end)
end

---@alias PackEvent "install" | "update" | "delete"

---Run a vim cmd string or lua function when a plugin is modified
---
---Wrapper around "PackChanged" autocmds to emulate lazy.nvim's `build` spec field.
---@param pkgname string The package name specified in vim.pack's `spec.name`
---@param cmd_or_func string | function Code to run when package status is changed
---@param on_change? PackEvent[] When to run. Any combination of {"install", "update", "delete"}. Default: {"install", "update"}
M.pack.run_on_build = function(pkgname, cmd_or_func, on_change)
    on_change = on_change or { "install", "update" }
    vim.validate("pkgname", pkgname, "string")
    vim.validate("cmd_or_func", cmd_or_func, { "string", "function" })
    vim.validate("on_change", on_change, on_change_validator)

    local call_type = type(cmd_or_func)

    vim.api.nvim_create_autocmd("PackChanged", {
        callback = function(event)
            local name, kind, path = event.data.spec.name, event.data.kind, event.data.spec.path
            -- Make sure pkgname and desired package change match
            if name == pkgname and vim.list_contains(on_change, kind) and vim.fn.isdirectory(path) then
                -- Load package if not loaded yet in case command requires it
                if not event.data.active then vim.cmd.packadd(pkgname) end
                -- Change directory to pkgdir
                vim.cmd.cd(path)
                -- Run given command
                if call_type == "string" then
                    vim.cmd(cmd_or_func)
                else
                    cmd_or_func()
                end
                -- Return to previous path
                vim.cmd.cd("-")
            end
        end,
    })
end

---@param name string
---@return boolean
local package_is_active = function(name)
    local active_pkgs = vim.iter(vim.pack.get())
        :filter(function(x)
            return x.active
        end)
        :map(function(x)
            return x.spec.name
        end)
        :totable()
    return vim.list_contains(active_pkgs, name)
end

---@alias PkgConfig table | function

---Run code only if a package with the given name is installed
---Useful for providing package configuration.
---
---The config can be given as a function to run, or a table, which will then be passed as an argument to `require(import_name).setup(config)`.
---@param name string Name of the package according to `vim.pack`
---@param config PkgConfig The package configuration
---@param import_name? string The name the package is called when `require`d
M.pack.configure_pkg = function(name, config, import_name)
    import_name = import_name or name:gsub("%.nvim$", ""):gsub("^nvim-", "")
    vim.validate("config", config, { "function", "table" })
    if package_is_active(name) then
        if type(config) == "function" then
            config()
        else
            require(import_name).setup(config)
        end
    end
end

---@alias Spec string | {name: string, ext: string}

---@param spec Spec The name of a treesitter parser and the extension of the file
local spec_validator = function(spec)
    local spec_type = type(spec)
    if spec_type == "string" then
        return true
    elseif spec_type == "table" then
        table.sort(spec)
        return vim.deep_equal(spec, { "ext", "name" })
    end
    return false
end

---Enable treesitter functionality for the given parsers
---@param specs Spec[] A list of treesitter parser specs to enable
M.treesitter.enable = function(specs)
    vim.validate("specs", specs, "table", false, "Spec[]")
    vim.iter(specs)
        :map(function(spec) -- Convert strings to dict format
            vim.validate("spec", spec, spec_validator)
            if type(spec) == "string" then
                return { name = spec, ext = spec }
            else
                return spec
            end
        end)
        :each(function(spec) -- Enable treesitter in buffer for language
            vim.api.nvim_create_autocmd("FileType", {
                pattern = spec.ext,
                callback = function(event)
                    vim.treesitter.start(event.buf, spec.lang)
                end,
            })
        end)
end

return M
