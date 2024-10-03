local setup = {
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        -- filetype to run formatters on all filetypes.
        ["*"] = { "codespell" },
        -- filetypes that don't have other formatters configured.
        ["_"] = { "trim_whitespace" },
    },
    format_after_save = {
        lsp_format = "prefer",
    },
}

local function formatters_config(conform)
    conform.formatters.isort = {
        prepend_args = { "--profile", "black" },
    }
end

return {
    "stevearc/conform.nvim",
    priority = 1000,
    config = function()
        local conform = require("conform")
        conform.setup(setup)
        formatters_config(conform)
        vim.keymap.set({ "n", "x" }, "<F3>", function()
            require("conform").format({ async = true })
        end)
    end
}
