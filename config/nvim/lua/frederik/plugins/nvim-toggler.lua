return {
	"nguyenvukhang/nvim-toggler",
	opts = {
		inverses = {
			["true"] = "false",
			["True"] = "False",
			["TRUE"] = "FALSE",
			["yes"] = "no",
			["on"] = "off",
			["left"] = "right",
			["up"] = "down",
			["enable"] = "disable",
			["!="] = "==",
			["!=="] = "===",
			["<="] = ">=",
			["<"] = ">",
			["||"] = "&&",
			["{"] = "}",
			["["] = "]",
			["("] = ")",
		},
		remove_default_keybinds = true,
		remove_default_inverses = true,
	},
	keys = {
		{
			"<leader>~",
			function()
				require("nvim-toggler").toggle()
			end,
			mode = { "n", "v" },
		},
	},
}
