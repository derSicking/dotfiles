vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<m-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<m-Up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<m-Down>", "V:m '>+1<CR>gv=")
vim.keymap.set("n", "<m-Up>", "V:m '<-2<CR>gv=")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "q:", "<nop>")
vim.keymap.set("", "<bs>", "<nop>")

vim.keymap.set({ "n", "v" }, "d", '"_d')
vim.keymap.set({ "n", "v" }, "D", '"_D')
vim.keymap.set({ "n", "v" }, "<bs>", '"_d')
vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set({ "n", "v" }, "C", '"_C')

vim.keymap.set("n", "dd", '"_dd')
vim.keymap.set("n", "cc", '"_cc')
vim.keymap.set("n", "x", '"_x')

vim.keymap.set("x", "p", '"_dP')

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<cr>")

vim.keymap.set("n", "<leader>%", ":vsplit<cr>")
vim.keymap.set("n", '<leader>"', ":split<cr>")

vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>Q", ":q<cr>")

vim.keymap.set("", "<RightMouse>", "<nop>")

vim.keymap.set("n", "<leader>f", vim.lsp.buf.code_action)
