return {
	"nvim-telescope/telescope.nvim",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
	config = function()
		local utils = require("telescope.utils")
		local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")

		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
			defaults = {
				mappings = {
					i = {
						["<esc>"] = actions.close,
					},
				},
			},
		})

		require("telescope").load_extension("ui-select")

		vim.keymap.set("n", "<C-p>", function()
			local _, ret, _ = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" })
			if ret == 0 then
				builtin.git_files({
					use_git_root = false,
					show_untracked = true,
				})
			else
				builtin.find_files({
					no_ignore = true,
					no_ignore_parent = true,
					follow = true,
				})
			end
		end)

		vim.keymap.set("n", "<leader><C-p>", function()
			builtin.find_files({
				no_ignore = true,
				no_ignore_parent = true,
				follow = true,
			})
		end, {})

		vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})
	end,
	keys = {
		{ "<c-p>" },
		{ "<leader><c-p>" },
		{ "<leader>ps" },
	},
}
