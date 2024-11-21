local function get_sketch(root_dir)
    local sketch_config_filename = "sketch.yaml"
    local path_sep = package.config:sub(1, 1)

    local current_dir = root_dir
    while current_dir do
        local sketch_path = current_dir .. path_sep .. sketch_config_filename
        local file = io.open(sketch_path, "r")

        if file then
            file:close()
            return sketch_path
        else
            -- Move up one directory
            local parent_dir = current_dir:match("^(.*)" .. path_sep)
            if parent_dir == current_dir then
                return nil
            end
            current_dir = parent_dir
        end
    end
end

local function get_sketch_fqbn(sketch_path)
    local file = io.open(sketch_path, "r")

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

    local fqbn = get_sketch_fqbn(get_sketch(root_dir)) or "arduino:avr:uno"

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
            vim.defer_fn(function()
                vim.lsp.buf_detach_client(bufnr, active_client.id)
            end, 10)
            break
        end
    end
end

return function()
    require("lspconfig").arduino_language_server.setup({
        filetypes = { "arduino", "cpp", "h", "c" },
        on_attach = on_attach,
        on_new_config = on_new_config,
    })
end
