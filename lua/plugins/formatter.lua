local function formatters_config(formatters)
    formatters.isort = {
        prepend_args = { "--profile", "black" },
    }
end

return {
    "stevearc/conform.nvim",
    priority = 1000,
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "black" },
            sh = { "beautysh" },
            bash = { "beautysh" },
            -- filetype to run formatters on all filetypes.
            ["*"] = { "codespell" },
            -- filetypes that don't have other formatters configured.
            ["_"] = { "trim_whitespace" },
        },
        format_after_save = {
            lsp_format = "prefer",
        },
    },
    config = function(_, opts)
        local conform = require("conform")
        conform.setup(opts)

        formatters_config(conform.formatters)

        vim.keymap.set({ "n", "x" }, "<F3>", function()
            require("conform").format({ async = true })
        end)
    end
}
