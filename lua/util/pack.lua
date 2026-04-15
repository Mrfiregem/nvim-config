---@alias PackEvent "install" | "update" | "delete"
---@alias PkgConfig table | function
---@alias OnPkgBuild string | function

---@class PkgSpec An extension of `vim.pack.Spec` to include some `lazy.nvim` features
---@field src string The url to the plugin's git repo
---@field name? string Name of the plugin. Used as directory name
---@field version? string|vim.VersionRange Version to use when updating
---@field depends? (string|PkgSpec)[] Extra packages required by the plugin
---@field build? string|function Vim command or lua functioin to run when package is installed or updated
---@field opts? table Package configuration passed to `require(pkgname).setup()`
---@field config? function Function containing package configuration code

local P = {}

---@param tbl string[]
local on_change_validator = function(tbl)
    return type(tbl) == "table"
        and vim.iter(tbl):all(function(val)
            return vim.list_contains({ "install", "update", "delete" }, val)
        end)
end

---Run a vim cmd string or lua function when a plugin is modified
---
---Wrapper around "PackChanged" autocmds to emulate lazy.nvim's `build` spec field.
---@param pkgname string The package name specified in vim.pack's `spec.name`
---@param cmd_or_func OnPkgBuild Code to run when package status is changed
---@param on_change? PackEvent[] When to run. Any combination of {"install", "update", "delete"}. Default: {"install", "update"}
P.run_on_build = function(pkgname, cmd_or_func, on_change)
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
                local old_dir = vim.fn.chdir(path)
                -- Run given command
                if call_type == "string" then
                    vim.cmd(cmd_or_func)
                else
                    cmd_or_func()
                end
                -- Return to previous path
                if old_dir ~= "" then vim.fn.chdir(old_dir) end
            end
        end,
    })
end

---@param s string
local convert_to_pkgspec = function(s)
    local _type = type(s)
    if _type == "table" then
        return s
    elseif _type == "string" then
        return { src = s }
    else
        error("Expected string or PkgSpec, got" .. _type)
    end
end

---@param s string|PkgSpec|vim.pack.Spec
local get_pkgname = function(s)
    if s.name then return s.name end
    local src = s.src or s
    vim.validate("src", src, "string")
    return vim.iter(vim.split(src, "/", { trimempty = true })):last()
end

---Wrapper around `vim.pack.add` to add dependencies and package configuration.
---@param pkglist (string|PkgSpec)[] List of packages to install
P.use = function(pkglist)
    ---@type PkgSpec[]
    local final = {}

    ---@type vim.pack.Spec[]
    local specs = vim.iter(pkglist)
        :map(convert_to_pkgspec)
        :map(function(spec)
            local result = {}
            local name = get_pkgname(spec)

            -- Generate autocmds for on pkg build
            if spec.build then P.run_on_build(name, spec.build) end

            -- Add official fields to resulting spec
            result.src = spec.src
            if spec.name then result.name = spec.name end
            if spec.version then result.version = spec.version end

            -- Note dependencies and move new fields to data subtable
            if spec.depends then
                local deps = vim.tbl_map(convert_to_pkgspec, spec.depends)
                vim.list_extend(final, deps)
                if not result.data then result.data = {} end
                result.data.depends = deps
            end
            if spec.build then
                if not result.data then result.data = {} end
                result.data.build = spec.build
            end
            if spec.opts then
                if not result.data then result.data = {} end
                result.data.opts = spec.opts
            end
            if spec.config then
                if not result.data then result.data = {} end
                result.data.config = spec.config
            end

            setmetatable(result, nil)
            return result
        end)
        :totable()

    vim.list_extend(final, specs)
    vim.list.unique(final, function(x)
        return x.src
    end)

    vim.pack.add(final)

    for pkg in
        vim.iter(vim.pack.get()):filter(function(p)
            return p.active
        end)
    do
        if pkg.spec.data and pkg.spec.data.opts then
            vim.validate("opts", pkg.spec.data.opts, "table")
            local name = get_pkgname(pkg.spec):gsub("%.nvim$", ""):gsub("^nvim%-", "")
            require(name).setup(pkg.spec.data.opts)
        end
        if pkg.spec.data and pkg.spec.data.config then
            vim.validate("config", pkg.spec.data.config, "function")
            pkg.spec.data.config()
        end
    end
end

---Get list of packages not already present on commandline
---@param current string The current token being completed
---@param cmdline string The entire cmdline of the call
---@return string[] packages Matching package names
P.cmdline_completer = function(current, cmdline)
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

return P
