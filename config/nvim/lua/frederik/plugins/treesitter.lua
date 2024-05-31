return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				ensure_installed = {},
				ignore_install = {},
				sync_install = false,
				auto_install = true,
				indent = { enable = true },
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<leader>v",
						node_incremental = "<leader>v",
						scope_incremental = false,
						node_decremental = "<leader>V",
					},
				},
				textobjects = {
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							[",w"] = { query = "@parameter.inner" },
						},
						goto_next_end = {
							[",e"] = { query = "@parameter.inner" },
						},
						goto_previous_start = {
							[",b"] = { query = "@parameter.inner" },
						},
					},
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["ia"] = { query = "@parameter.inner" },
							["aa"] = { query = "@parameter.outer" },
							["f"] = { query = "@function.inner" },
							["if"] = { query = "@function.inner" },
							["af"] = { query = "@function.outer" },
						},
					},
				},
			})
		end,
	},
}
