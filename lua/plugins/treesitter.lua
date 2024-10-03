return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            -- Languages
            "c",
            "cpp",
            "python",
            "rust",
            "lua",
            "c_sharp",
            "matlab",
            -- terminal utils
            "bash",
            "powershell",
            "ssh_config",
            "make",
            "sql",
            -- webshit
            "javascript",
            "html",
            "css",
            -- utils
            "markdown",
            "vim",
            "vimdoc",
            "query",
            "heex",
        },

        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    },

    config = function(_, opts)
        local configs = require("nvim-treesitter.configs")

        configs.setup(opts)
    end,
}
