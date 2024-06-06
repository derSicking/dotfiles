return {
	"mg979/vim-visual-multi",
	config = function()
		vim.api.nvim_set_hl(0, "VM_Mono", { link = "Cursor" })
		vim.api.nvim_set_hl(0, "VM_Extend", { link = "Visual" })
		vim.api.nvim_set_hl(0, "VM_Cursor", { link = "Cursor" })
		vim.api.nvim_set_hl(0, "VM_Insert", { link = "Cursor" })
	end,
	init = function()
		vim.g.VM_maps = {
			["Add Cursor Up"] = "",
			["Add Cursor Down"] = "",
		}
	end,
}
