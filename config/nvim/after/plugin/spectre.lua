local spectre = require("spectre")

spectre.setup({
	highlight = {
		ui = "String",
		search = "DiffDelete",
		replace = "DiffAdd",
	},
	find_engine = {
		["rg"] = {
			cmd = "rg",
			args = {
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--follow",
				"--no-ignore",
			},
		},
	},
})

vim.keymap.set("n", "<leader>S", function()
	spectre.toggle()
end)

vim.keymap.set("n", "<leader>sw", function()
	spectre.open_visual({ select_word = true })
end)

vim.keymap.set("v", "<leader>sw", function()
	spectre.open_visual()
end)

vim.keymap.set("n", "<leader>sf", function()
	spectre.open_file_search({ select_word = true })
end)
