local function get_sketch_fqbn(root_dir)
    local fqbn_value = nil

    local sketch_config = "sketch.yaml"
    local path_sep = package.config:sub(1, 1)

    local current_dir = root_dir
    while current_dir do
        local sketch_path = current_dir .. path_sep .. sketch_config
        local file = io.open(sketch_path, "r")

        if file then
            for line in file:lines() do
                fqbn_value = line:match("^default_fqbn:%s*(.+)")
                if fqbn_value then
                    break
                end
            end
            file:close()
            break -- if found sketch config stop searching
        else
            -- Move up one directory
            local parent_dir = current_dir:match("^(.*)" .. path_sep)
            if parent_dir == current_dir then break end
            current_dir = parent_dir
        end
    end

    return fqbn_value
end

local function on_new_config(config, root_dir)
    local clangd = vim.fn.system("which clangd")

    local arduino_cli = vim.fn.system("which arduino-cli")

    local arduino_cli_config = vim.fn.system([[
    arduino-cli config get directories.data | head -n1 | xargs -I {} echo '{}/arduino_cli.yaml'
    ]])

    local fqbn = get_sketch_fqbn(root_dir) or "arduino:avr:uno"

    if not fqbn then
        return
    end

    config.cmd = {
        "arduino-language-server",
        "-clangd", clangd,
        "-cli", arduino_cli,
        "-cli-config", arduino_cli_config,
        "-fqbn", fqbn,
    }

    config.capabilities.textDocument.semanticTokens = vim.NIL
    config.capabilities.workspace.semanticTokens = vim.NIL
end

return function()
    require("lspconfig").arduino_language_server.setup({
        on_attach = function(client)
            client.capabilities.textDocument.semanticTokens = false
            client.capabilities.workspace.semanticTokens = false
        end,
        on_new_config = on_new_config,
    })
end
