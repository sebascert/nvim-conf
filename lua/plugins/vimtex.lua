-- Note: require tree-sitter cli

return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        vim.g.tex_flavor = "latex"
        -- vim.g.tex_conceal = ""
        vim.g.tex_conceal = "abdmg"
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" }
        vim.g.vimtex_quickfix_mode = 0
        -- vim.o.conceallevel = 2
    end
}
