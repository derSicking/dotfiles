return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = true,
	opts = {
		close_if_last_window = true,
		filesystem = {
			hijack_netrw_behavior = "disabled",
			follow_current_file = {
				enabled = true,
				leave_dirs_open = true,
			},
		},
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree show toggle reveal<cr>" },
		{ "<leader>gt", "<cmd>Neotree show toggle reveal git_status<cr>" },
	},
}
