vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	group = vim.api.nvim_create_augroup("markdown-start", { clear = true }),
	callback = function()
		vim.opt_local.conceallevel = 2
	end,
})
