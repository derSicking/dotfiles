vim.opt.termguicolors = true

require("tokyonight").setup({
	style = "night",
	light_style = "day",
	terminal_colors = true,
	dim_inactive = true,
})

vim.cmd.colorscheme("tokyonight")
