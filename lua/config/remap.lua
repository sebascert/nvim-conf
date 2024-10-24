vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap.set
local cmd = vim.api.nvim_create_user_command

keymap("n", "<leader>pv", vim.cmd.Ex)

keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

keymap("n", "J", "mzJ`z")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzz")
keymap("n", "N", "Nzz")

keymap("x", "<leader>p", [["_dP]])
keymap({ "n", "v" }, "<leader>d", [["_d]])

keymap("n", "<leader>Y", [["+Y]])
keymap({ "n", "v" }, "<leader>y", [["+y]])

keymap("i", "<C-c>", "<Esc>")

keymap("n", "Q", "<nop>")

keymap("n", "<C-k>", "<cmd>cnext<CR>zz")
keymap("n", "<C-j>", "<cmd>cprev<CR>zz")
keymap("n", "<leader>k", "<cmd>lnext<CR>zz")
keymap("n", "<leader>j", "<cmd>lprev<CR>zz")

keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap("n", "<leader>S", [[:%s/<C-r>"/<C-r>"/gI<Left><Left><Left>]])

keymap("n", "<leader>D",
    "<cmd>lua vim.diagnostic.open_float(nil, { focusable = false })<CR>",
    { noremap = true, silent = true })

-- keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

keymap("n", "<leader>bn", vim.cmd.bn)
keymap("n", "<leader>bp", vim.cmd.bp)
keymap("n", "<leader>bls", vim.cmd.ls)
keymap("n", "<leader>bd", vim.cmd.bd)

keymap("n", "<C-PageUp>", vim.cmd.bn)
keymap("n", "<C-PageDown>", vim.cmd.bp)

keymap("n", "<leader><leader>", vim.cmd.so)

cmd("Bcppath", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
end, {})
