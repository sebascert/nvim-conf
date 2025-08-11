vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap.set
local cmd = vim.api.nvim_create_user_command

-- netrw alias
keymap("n", "<leader>pv", vim.cmd.Ex)

-- jk displace selected lines
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- displace line below to cursor line
keymap("n", "J", "mzJ`z")

-- up/down and center
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
-- next/prev and center
keymap("n", "n", "nzz")
keymap("n", "N", "Nzz")

-- paste and discard yank
keymap("x", "<leader>p", [["_dP]])

-- delete and discard yank
keymap({ "n" }, "<leader>D", [["_d$]])
keymap({ "n", "v" }, "<leader>d", [["_d]])
-- change and discard yank
keymap({ "n" }, "<leader>C", [["_c$]])
keymap({ "n", "v" }, "<leader>c", [["_c]])

-- yank to clipboard
keymap("n", "<leader>Y", [["+y$]])
keymap({ "n", "v" }, "<leader>y", [["+y]])

keymap("i", "<C-c>", "<Esc>")

keymap("n", "<C-k>", "<cmd>cnext<CR>zz")
keymap("n", "<C-j>", "<cmd>cprev<CR>zz")
keymap("n", "<leader>k", "<cmd>lnext<CR>zz")
keymap("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace word in buff
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- replace yank in buff
keymap("n", "<leader>S", [[:%s/<C-r>"/<C-r>"/gI<Left><Left><Left>]])

keymap(
    "n",
    "Q",
    "<cmd>lua vim.diagnostic.open_float(nil, { focusable = false })<CR>",
    { noremap = true, silent = true }
)

-- keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- buffer operations
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

cmd("Nw", "noautocmd w", {})
