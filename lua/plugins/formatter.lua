local function formatters_config(formatters) end

return {
    "stevearc/conform.nvim",
    priority = 1000,
    opts = {
        formatters_by_ft = {
            rust = { "rustfmt" },
            lua = { "stylua" },
            sh = { "beautysh" },
            bash = { "beautysh" },
            markdown = { "prettier" },
            -- filetype to run formatters on all filetypes.
            ["*"] = { "trim_whitespace" },
            -- filetypes that don't have other formatters configured.
            ["_"] = { "trim_whitespace" },
        },
        format_after_save = {
            lsp_format = "fallback",
        },
    },
    config = function(_, opts)
        local conform = require("conform")
        conform.setup(opts)

        formatters_config(conform.formatters)

        vim.keymap.set({ "n", "x" }, "<F3>", function()
            require("conform").format({ async = true })
        end)
    end,
}
