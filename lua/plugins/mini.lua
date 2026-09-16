local function mini(name, opts)
    return {
        string.format("nvim-mini/mini.%s", name),
        version = false,
        opts = opts or {},
    }
end

return {
    mini("pairs"),
    mini("surround"),
}
