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
            sql = { "sqlfmt" },
            markdown = { "dprint" },
            scheme = { "dprint" },
            -- filetype to run formatters on all filetypes.
            ["*"] = { "trim_whitespace" },
            -- filetypes that don't have other formatters configured.
            ["_"] = { "trim_whitespace" },
        },
        formatters = {
            injected = { options = { ignore_errors = true } },
            -- # Example of using dprint only when a dprint.json file is present
            dprint = {
                condition = function(ctx)
                    return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
                end,
            },
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
