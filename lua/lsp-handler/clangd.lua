local function on_attach(client, bufnr)
    -- detach clangd on attached arduino-ls
    for _, active_client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if active_client.name == "arduino_language_server" then
            vim.defer_fn(function()
                vim.lsp.buf_detach_client(bufnr, client.id)
            end, 10)
            break
        end
    end
end

return function()
    require("lspconfig").clangd.setup({
        on_attach = on_attach,
    })
end
