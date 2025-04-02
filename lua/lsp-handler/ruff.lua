return function()
    require("lspconfig").ruff.setup({
        init_options = {
            settings = {
                logLevel = "error",
                configurationPreference = "filesystemFirst",
                organizeImports = true,
            },
            configuration = {
                unsafe_fixes = true,
            },
        },
    })
end
