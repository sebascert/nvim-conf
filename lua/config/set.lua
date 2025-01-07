vim.opt.guicursor = ""

-- LINE NUMBERING
vim.opt.nu = true
vim.opt.relativenumber = true

-- WHITESPACE
vim.opt.list = true
vim.opt.listchars = {
    -- space = "·",
    tab = "→ ",
    trail = "·",
    extends = ">",
    precedes = "<",
}

-- TABS AND INDENT
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- TMP FILES
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- SEARCH
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- GENERIC
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes:2"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

-- vim.opt.clipboard:append("unnamedplus")
