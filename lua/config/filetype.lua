local dir = vim.fn.stdpath("config") .. "/lua/config/filetype/"
local path = vim.fs.normalize(dir)

for file, _ in vim.fs.dir(path) do
    if file:match("%.lua$") then
        local filename = file:sub(1, -5)
        local success, err = pcall(require, "config.filetype." .. filename)
        if not success then
            print("Error loading " .. filename .. ": " .. err)
        end
    end
end

-- File Mapping

local mappings = {
    shebang_mapping = function()
        local first_line = vim.fn.getline(1)

        if not string.match(first_line, "^#!") then
            return
        end

        if string.match(first_line, "bash") then
            vim.bo.filetype = "bash"
        elseif string.match(first_line, "sh") then
            vim.bo.filetype = "sh"
        elseif string.match(first_line, "python") then
            vim.bo.filetype = "python"
        end
    end,
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*",
    callback = function()
        for _, mapping in pairs(mappings) do
            mapping()
        end
    end
})
