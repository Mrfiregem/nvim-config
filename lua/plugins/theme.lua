local ayu = {
    "shatur/neovim-ayu",
    priority = 1000,
    init = function()
        vim.cmd.colorscheme("ayu")
    end,
}

local lualine = {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
        options = {
            theme = "ayu",
        },
    },
}

return {
    ayu,
    lualine,
}
