return function()
    require("lspconfig").ruff.setup({
        init_options = {
            settings = {
                logLevel = "debug",
                configurationPreference = "filesystemFirst",
                organizeImports = true,
            },
        },
    })
end
