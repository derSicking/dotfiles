vim.opt.relativenumber = true

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

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "81"

vim.opt.clipboard = "unnamedplus"

vim.opt.fillchars = { eob = " " }

vim.opt.guicursor =
	"n-v-c:block,i-ci-ve:ver25,r-cr-o:hor25,i-ci-ve:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.cmd.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })
vim.cmd.aunmenu({ "PopUp.-1-" })
