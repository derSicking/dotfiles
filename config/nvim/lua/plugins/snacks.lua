vim.pack.add({ { src = "https://github.com/folke/snacks.nvim" } })

local snacks = require("snacks")

snacks.setup({
	indent = {},
	input = {},
	scroll = {},
	explorer = {},
	terminal = {},
	picker = {
		win = {
			input = {
				keys = {
					["<Esc>"] = { "close", mode = { "n", "i" } },
				},
			},
		},
	},
})

vim.api.nvim_create_user_command("Colorscheme", snacks.picker.colorschemes, {})

vim.keymap.set("n", "<leader>e", snacks.explorer.open)
vim.keymap.set("n", "<c-p>", snacks.picker.files)
vim.keymap.set("n", "<leader>ps", snacks.picker.grep)
vim.keymap.set("n", "<leader>pb", snacks.picker.buffers)
