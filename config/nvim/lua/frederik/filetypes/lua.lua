vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	group = vim.api.nvim_create_augroup("lua-start", { clear = true }),
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt.expandtab = false
	end,
})
