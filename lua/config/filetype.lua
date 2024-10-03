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
