vim.opt.relativenumber = true
vim.opt.number = true

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("set-formatoptions", { clear = true }),
	callback = function()
		vim.opt.formatoptions = "jql"
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
	group = vim.api.nvim_create_augroup("relativenumber-on", { clear = true }),
	callback = function()
		vim.opt.relativenumber = true
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	group = vim.api.nvim_create_augroup("relativenumber-off", { clear = true }),
	callback = function()
		vim.opt.relativenumber = false
	end,
})

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "81"
vim.opt.cursorline = true

vim.opt.clipboard = "unnamedplus"

vim.opt.fillchars = { eob = " " }

vim.opt.guicursor =
	"n-v-c:block,i-ci-ve:ver25,r-cr-o:hor25,i-ci-ve:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.cmd.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })
vim.cmd.aunmenu({ "PopUp.-1-" })
