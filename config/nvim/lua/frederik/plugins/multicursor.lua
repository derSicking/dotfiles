return {
	"mg979/vim-visual-multi",
	config = function()
		vim.api.nvim_set_hl(0, "VM_Mono", { link = "Cursor" })
		vim.api.nvim_set_hl(0, "VM_Extend", { link = "Visual" })
		vim.api.nvim_set_hl(0, "VM_Cursor", { link = "Cursor" })
		vim.api.nvim_set_hl(0, "VM_Insert", { link = "Cursor" })
	end,
}
