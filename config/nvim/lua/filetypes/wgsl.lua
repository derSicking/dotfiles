vim.api.nvim_create_autocmd("FileType", {
	pattern = "wgsl",
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.softtabstop = 4
		vim.bo.shiftwidth = 4
	end,
})
