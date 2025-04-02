local function on_attach(client, bufnr)
    -- if ruff is used disable certain capabilities
    for _, active_client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if active_client.name == "ruff" then
            active_client.capabilities.textDocument.hover = nil
            client.capabilities.disableOrganizeImports = true
            client.settings.python.analysis.ignore = { "*" }
            break
        end
    end
end

ToggleLinting(false)
return function()
    require("lspconfig").pyright.setup({
        on_attach = on_attach,
    })
end
