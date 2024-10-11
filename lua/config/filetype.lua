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

local MAX_PRIORITY = 3
local MID_PRIORITY = 2
local LOW_PRIORITY = 1
local NO_PRIORITY = 0 -- No mapping should have this priority

local mappings = {
    { -- extension
        priority = MAX_PRIORITY,
        map = function()
            local buf = vim.api.nvim_get_current_buf()
            local buf_name = vim.api.nvim_buf_get_name(buf)

            if string.match(buf_name, ".h$") then
                return "c"
            elseif string.match(buf_name, ".hpp$") then
                return "cpp"
            end
        end,
    },

    { -- shebang
        priority = LOW_PRIORITY,
        map = function()
            local first_line = vim.fn.getline(1)

            if not string.match(first_line, "^#!") then
                return
            end

            if string.match(first_line, "bash") then
                return "bash"
            elseif string.match(first_line, "sh") then
                return "sh"
            elseif string.match(first_line, "python") then
                return "python"
            end
        end,
    },
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*",
    callback = function()
        local filetype = ""
        local priority = NO_PRIORITY

        for _, mapping in pairs(mappings) do
            if mapping.priority < priority then
                goto continue
            end

            local mapped = mapping.map()
            -- print("mapped", mapped)
            if mapped == nil then
                goto continue
            end

            if mapping.priority > priority then
                priority = mapping.priority
                filetype = mapped
            elseif mapping.priority == priority then
                if filetype == mapped then
                    goto continue
                end

                error("filetype determination conflict")
                error("incompatible " .. filetype " and " .. mapped)
                return
            end
            ::continue::
        end

        if priority ~= NO_PRIORITY then
            vim.bo.filetype = filetype
        end
    end
})
