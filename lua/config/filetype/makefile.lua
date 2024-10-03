local function configs()
    vim.opt_local.expandtab = false
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "makefile",
    callback = configs,
})
