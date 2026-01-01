local CP_PROFILE_FILE = ".nvim_cp_profile"

local function has_cp_profile()
    local cwd = vim.fn.getcwd()
    local file = cwd .. "/" .. CP_PROFILE_FILE
    return vim.fn.filereadable(file) == 1
end

vim.g.CP_PROFILE = has_cp_profile()

if vim.g.CP_PROFILE then
    vim.g.linting = false
end
