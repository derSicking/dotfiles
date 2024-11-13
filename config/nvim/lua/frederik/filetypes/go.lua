vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	group = vim.api.nvim_create_augroup("go-start", { clear = true }),
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = false
	end,
})
