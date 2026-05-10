vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("v", "<m-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<m-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<m-j>", "V:m '>+1<CR>gv=")
vim.keymap.set("n", "<m-k>", "V:m '<-2<CR>gv=")
vim.keymap.set("v", "<m-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<m-Up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<m-Down>", "V:m '>+1<CR>gv=")
vim.keymap.set("n", "<m-Up>", "V:m '<-2<CR>gv=")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "q:", "<nop>")
vim.keymap.set("", "<bs>", "<nop>")

vim.keymap.set({ "n", "v" }, "d", '"_d')
vim.keymap.set({ "n", "v" }, "D", '"_D')
vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set({ "n", "v" }, "C", '"_C')

vim.keymap.set("n", "dd", '"_dd')
vim.keymap.set("n", "cc", '"_cc')
vim.keymap.set("n", "x", '"_x')

vim.keymap.set("x", "p", '"_dP')

vim.keymap.set("n", "<leader>m", "q")
vim.keymap.set("", "q", "")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<cr>")
vim.keymap.set("n", "<leader>!x", "<cmd>!chmod -x %<cr>")

vim.keymap.set("n", "<leader>%", ":vsplit<cr>")
vim.keymap.set("n", '<leader>"', ":split<cr>")

vim.keymap.set("n", "<c-s-h>", "<c-w>2<")
vim.keymap.set("n", "<c-s-j>", "<c-w>-")
vim.keymap.set("n", "<c-s-k>", "<c-w>+")
vim.keymap.set("n", "<c-s-l>", "<c-w>2>")

vim.keymap.set("n", "<leader>w", ":w<cr>")

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

vim.keymap.set("n", "<leader>dj", function()
	vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("n", "<leader>dk", function()
	vim.diagnostic.jump({ count = -1, float = true })
end)

vim.keymap.set("n", "<leader>u", "<cmd>Undotree<cr>")

local all_modes = { "n", "v", "i", "c", "o", "t", "l" }

vim.keymap.set(all_modes, "<RightMouse>", "<nop>")
vim.keymap.set(all_modes, "", "<nop>")
vim.keymap.set(all_modes, "<F1>", "<nop>")

vim.keymap.set("n", "<space>", "<nop>")
vim.keymap.set("n", "<leader>p", "<nop>")

vim.api.nvim_create_user_command("PackUpdate", function()
	vim.pack.update()
end, {})
