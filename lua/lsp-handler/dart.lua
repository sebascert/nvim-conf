return function()
    require("lspconfig").dartls.setup({
        cmd = { "dart", "language-server", "--protocol=lsp" },
        settings = {
            dart = {
                completeFunctionCalls = true,
                showTodos = true,
                updateImportsOnRename = true,
                lineLength = 100,
                enableSdkFormatter = true,
                analysisExcludedFolders = { "build", ".dart_tool" },
            },
        },
    })
end
