vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	group = vim.api.nvim_create_augroup("java-start", { clear = true }),
	callback = function()
		vim.opt.tabstop = 4
		vim.opt.softtabstop = 4
		vim.opt.shiftwidth = 4
	end,
})
