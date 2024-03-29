return {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
			providers = {
				"lsp",
				-- "treesitter",
				-- "regex",
			},
			modes_allowlist = { "n" },
		})
	end,
}
