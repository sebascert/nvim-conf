local function get_sketch_fqbn(sketch_root)
    local path_sep = package.config:sub(1, 1)
    local file = io.open(sketch_root .. path_sep .. "sketch.yaml", "r")

    if not file then
        return nil
    end

    local fqbn_value = nil
    for line in file:lines() do
        fqbn_value = line:match("^default_fqbn:%s*(.+)")
        if fqbn_value then
            break
        end
    end

    file:close()

    return fqbn_value
end

local function on_new_config(config, root_dir)
    local clangd = vim.fn.system("which clangd"):gsub("%s+$", "")

    local arduino_cli = vim.fn.system("which arduino-cli"):gsub("%s+$", "")

    local arduino_cli_config = vim.fn.system("arduino-cli config get directories.data")
    arduino_cli_config = arduino_cli_config:gsub("%s+$", "") .. "/arduino_cli.yaml"

    local fqbn = get_sketch_fqbn(root_dir) or "arduino:avr:uno"

    if not fqbn then
        return
    end

    config.cmd = {
        "arduino-language-server",
        "-clangd",
        clangd,
        "-cli",
        arduino_cli,
        "-cli-config",
        arduino_cli_config,
        "-fqbn",
        fqbn,
    }
end

local function on_attach(client, bufnr)
    client.capabilities.textDocument.semanticTokens = false
    client.capabilities.workspace.semanticTokens = false

    -- detach clangd
    for _, active_client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if active_client.name == "clangd" then
            -- active_client.handlers["textDocument/publishDiagnostics"] = function() end
            vim.defer_fn(function()
                vim.lsp.buf_detach_client(bufnr, active_client.id)
            end, 10)
            break
        end
    end
    ToggleLinting(false)
end

local function on_deattach()
    ToggleLinting(true)
end

return function()
    require("lspconfig").arduino_language_server.setup({
        root_dir = vim.fs.root(0, { "sketch.yaml", "*.ino" }),
        filetypes = { "arduino", "cpp", "h", "c" },
        on_attach = on_attach,
        on_deattach = on_deattach,
        on_new_config = on_new_config,
    })
end
