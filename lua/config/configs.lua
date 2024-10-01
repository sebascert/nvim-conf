local autocmd = vim.api.nvim_create_autocmd

-- highlight on yank

autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 50,
        })
    end,
})
