return function()
    local lspconfig = require("lspconfig")
    local config = lspconfig.clangd.document_config

    config.filetypes = config.filetypes or {}
    table.insert(config.filetypes, "arduino")

    lspconfig.clangd.setup(config)
end
